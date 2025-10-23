import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dqueuedoc/controller/managers/state_manager.dart';
import 'package:dqueuedoc/model/core/basic_response_model.dart';
import 'package:dqueuedoc/model/core/drug_params_model.dart';
import 'package:dqueuedoc/model/core/prescription_save_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_user.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/accept_request_response_model.dart';
import '../../model/core/analytics_model.dart';
import '../../model/core/consultations_list__model.dart';
import '../../model/core/patients_details_model.dart';
import '../../model/core/patients_requests_model.dart';
import '../../model/core/prescription_model.dart';
import '../../model/core/prescription_preview_model.dart';
import '../../model/core/recent_patients_response_model.dart';
import '../../model/core/upcoming_appoinments_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../../view/theme/constants.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

class OnlineConsultManager extends ChangeNotifier {
  // List<String> selectedDiagnList = [];
  String selectedDuration = "Days";
  String selectedIntervalType = "Hour";
  String searchQuery = '';
  BasicListItem? selectedDrug;
  List<TextMessage> cMessages = [];
  bool patientsReqLoader = true;
  int selectedInterval = 0;
  DrugParams? drugParams;
  Param? selectedDrugType;
  Param? selectedDrugUnit;
  Param? doseM;
  Param? doseA;
  Param? doseE;
  Param? doseN;
  List<RecentPatients>? recentPatients;
  DateTime selectedDt = DateTime.now();
  List<PatientDetails> patientsReqList = [];

  Map<String, bool> patientsReqListId = {};
  bool scheduledBookloader = false;
  PrescriptionModel presModel = PrescriptionModel(drugsList: []);
  bool paginationLoader = false;
  // List<Consultations> consultations = [];
  ConsultaitionsModel? consultationsModel;
  bool bookingDetailsLoader = false;
  UserDetails? patientDetails;
  BookingDetails? bookingDetails;
  List<Questionnaire>? questionnaire;
  bool consultLoader = false;
  bool callingLoader = false;
  bool priscriptionLoader = false;
  // bool showFilter = false;
  int? loaderBookingId;
  DateIntervals? consultationsDateIntervals;
  bool? showSmallPoints;
  String? selectedPositionId;
  bool? isLoading = false;

  setShowSmallPoints(bool value) {
    showSmallPoints = value;
    notifyListeners();
  }

  addNewDrugToDrugParams(Drug drug) {
    drugParams!.drugs!.add(drug);
    notifyListeners();
    setDrugName(BasicListItem(id: drug.id, item: drug.title));
  }

  setSelectedSmallPoint(String? pointId) {
    selectedPositionId = pointId;
    notifyListeners();
  }

  setDateInteval({DateTime? startDay, DateTime? endDay, bool? isDispose}) {
    if (startDay != null && endDay != null) {
      consultationsDateIntervals = DateIntervals(
        startDate: startDay,
        endDate: endDay,
      );
    } else {
      consultationsDateIntervals = null;
    }
    if (isDispose != true) {
      notifyListeners();
    }
  }
  // setFilterShowStatus(){
  //   showFilter = !showFilter;
  //   notifyListeners();
  // }

  loadingSpecificBooking(int? bookingId) {
    loaderBookingId = bookingId;
    notifyListeners();
  }

  confirmCallCompletion(bookId) async {
    String endpoint = Endpoints.confirmCallCompletion;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {"booking_id": bookId};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (kDebugMode) {
      print(responseData["message"]);
    }

    if (responseData != null) {
      var res = BasicResponseModel.fromJson(responseData);

      return res;
    } else {
      return BasicResponseModel(status: false, message: "server error");
    }
  }

  shareAnatomyImage({
    int? bookId,
    String? left,
    String? top,
    required String imageName,
  }) async {
    String endpoint = Endpoints.showAnatomyImage;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {
      "booking_id": bookId,
      "x_axis_point": left,
      "y_axis_point": top,
      "image": imageName,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (kDebugMode) {
      print(responseData["message"]);
    }

    if (responseData != null) {
      var res = BasicResponseModel.fromJson(responseData);

      return res;
    } else {
      return BasicResponseModel(status: false, message: "server error");
    }
  }

  markConsultationStartedLocally(bookId) {
    for (Consultations i in consultationsModel?.consultations ?? []) {
      if (i.id == bookId) {
        i.bookingStatus = "Completed";
      }
    }
    notifyListeners();
  }

  markAppointmentsStartedLocally(bookId) {
    for (UpcomingAppointments i in upcomingAppointments ?? []) {
      if (i.id == bookId) {
        i.bookingStatus = "Completed";
      }
    }
    notifyListeners();
  }

  List<UpcomingAppointments>? upcomingAppointments = [
    // UpcomingAppointments(speciality: "Councelling",time:"10:00 AM",patientFirstName: "Ramees", patientAge: 24,patientGender: "Male"),
    // UpcomingAppointments(speciality: "Councelling",time:"10:00 AM",patientFirstName: "Ramees", patientAge: 24,patientGender: "Male"),
    // UpcomingAppointments(speciality: "Councelling",time:"10:00 AM",patientFirstName: "Ramees", patientAge: 24,patientGender: "Male"),
    // UpcomingAppointments(speciality: "Councelling",time:"10:00 AM",patientFirstName: "Ramees", patientAge: 24,patientGender: "Male"),
  ];

  ZoomVideoSdkUser? usersmallUser;
  var zoom = ZoomVideoSdk();

  Future<bool> checkisUserAvailable() async {
    List<ZoomVideoSdkUser>? users = await zoom.session.getRemoteUsers();
    return users != null && users.isNotEmpty;
  }

  void onLeaveSession(bool isEndSession) async {
    await zoom.leaveSession(isEndSession);
    setSmallUser(user: null);
    // Navigator.pop(context);
  }

  setSmallUser({ZoomVideoSdkUser? user}) {
    usersmallUser = user;
    notifyListeners();
  }

  Future<BasicResponseModel> cancelBooking({required int bookingId}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    // setProfileLoader(true);

    String endpoint = Endpoints.doctorCancelBooking;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {"booking_id": bookingId};
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    // setProfileLoader(false);
    // notifyListeners();
    if (responseData != null) {
      return BasicResponseModel.fromJson(responseData);
    } else {
      return BasicResponseModel(message: "No data", status: false);
    }
  }

  disposePriscrip() {
    presModel = PrescriptionModel(drugsList: []);
  }

  disposeChat() {
    cMessages = [];
  }

  Future<BasicResponseModel> initiateCall({
    required int bookingId,
    bool? forStatusCheck,
  }) async {
    // await Future.delayed(Duration(milliseconds: 50));
    callingLoader = true;
    notifyListeners();
    String endpoint = Endpoints.callConnection;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {
      "booking_id": bookingId,
      "user_type": 1,
      "call_status_checking": forStatusCheck == true ? true : false,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    callingLoader = false;
    notifyListeners();
    if (responseData != null) {
      var result = BasicResponseModel.fromJson(responseData);
      return result;
      //   patientsReqList  = result.patientDetails ?? [];
    } else {
      return BasicResponseModel(status: false, message: "no data");
    }
  }

  void addMessageToChat(TextMessage message) {
    cMessages.insert(0, message);
    notifyListeners();
  }

  void loadMessageToChat(List<TextMessage> messages) {
    cMessages = messages;
    notifyListeners();
  }

  setConsultLoader(bool val) {
    consultLoader = val;
    notifyListeners();
  }

  disposeAddDrug() {
    selectedDrug = null;
    selectedDuration = "Days";
    selectedIntervalType = "Hour";
    selectedInterval = 0;
    selectedDrugType = null;
    selectedDrugUnit = null;
    doseM = null;
    doseA = null;
    doseE = null;
    doseN = null;
  }

  removeDrugItem(int indx) {
    if (presModel.drugsList.isNotEmpty) {
      presModel.drugsList.removeAt(indx);
    }
    notifyListeners();
  }

  setPriscriptionLoader(bool val) {
    priscriptionLoader = val;
    notifyListeners();
  }

  Future<PrescriptionPreviewModel> sendPrescription({
    required int bookingId,
  }) async {
    setPriscriptionLoader(true);
    notifyListeners();
    print(presModel.toJson());

    List<int> existingPastMEdicalHistory = getListItemWithId(
      presModel.pastMedications ?? [],
    );
    List<String> newPastMedications = getListItemWithoutId(
      presModel.pastMedications ?? [],
    );
    List<int> existingLabTestList = getListItemWithId(
      presModel.labTestList ?? [],
    );
    List<String> newLabTestList = getListItemWithoutId(
      presModel.labTestList ?? [],
    );

    PriscriptionSaveModel pSaveModel = PriscriptionSaveModel(
      bookingId: bookingId,
      height: presModel.height != null ? double.parse(presModel.height!) : null,
      weight: presModel.weight != null ? double.parse(presModel.weight!) : null,
      allergy: presModel.allergy,
      bloodGroup: presModel.bloodGroup,
      pastMedicalHistory: presModel.pastMedHistory,
      existingPastMedicationList: existingPastMEdicalHistory,
      newPastMedicationList: newPastMedications,
      complaints: presModel.complaints,
      diagnosis: presModel.diagnosis,
      observations: presModel.observations,
      existingLabTestList: existingLabTestList,
      newLabTestList: newLabTestList,
      doctorInstructions: presModel.doctorInstructions,
      doctorNote: presModel.doctorNote,
      labTestRemark: presModel.labTestRemark,
      drugsList: presModel.drugsList.map((e) {
        FixedInterval? fxdI = e.fixedInterval;
        VariableInterval? varI = e.variableInterval;

        return DrugsList(
          dailyMedication: fxdI != null ? "Yes" : "No",
          intervalType: varI?.intervalType,
          dosage: varI?.dosage,
          eveningDosage: double.parse(fxdI?.eveningDosage?.title ?? "0"),
          nightDosage: double.parse(fxdI?.nightDosage?.title ?? "0"),
          morningDosage: double.parse(fxdI?.morningDosage?.title ?? "0"),
          afternoonDosage: double.parse(fxdI?.afternoonDosage?.title ?? "0"),
          duration: e.duration,
          drugTypeId: e.drugType?.id,
          drugUnitId: e.drugUnit?.id,
          durationType: fxdI?.intervalType ?? varI?.durationType,
          interval: e.variableInterval?.interval,
          medicineInstruction: e.instructions,
          drug: SingleDrugItem(id: e.drug?.id, name: e.drug?.item),
        );
      }).toList(),
    );

    print(pSaveModel.toJson());

    String endpoint = Endpoints.prescripSave;
    Map<String, dynamic> data = pSaveModel.toJson();
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    setPriscriptionLoader(false);

    if (responseData != null) {
      var dt = PrescriptionPreviewModel.fromJson(responseData);
      return dt;

      // notifyListeners();
    } else {
      return PrescriptionPreviewModel(status: false, message: "No data");
    }
  }

  List<int> getListItemWithId(List<BasicListItem> lst) {
    List<int> ids = [];
    for (var i in lst) {
      if (i.id != null) {
        ids.add(i.id!);
      }
    }
    return ids;
  }

  List<String> getListItemWithoutId(List<BasicListItem> lst) {
    List<String> items = [];
    for (var i in lst) {
      if (i.id == null) {
        items.add(i.item!);
      }
    }
    return items;
  }

  addDrug(DrugItem item) {
    presModel.drugsList.add(item);
    notifyListeners();
  }

  setDurationFactor(String? durFact) {
    if (durFact != null) {
      selectedDuration = durFact;
    }
    notifyListeners();
  }

  setIntervalFactor(int index) {
    selectedInterval = index;
    notifyListeners();
  }

  // List<PatientDetails> patientsReqList =[];

  addDiagnosis(List<String> items) {
    presModel.diagnosis = [];
    presModel.diagnosis!.addAll(items);

    notifyListeners();
  }

  addLabTests(List<BasicListItem> items) {
    presModel.labTestList = [];
    presModel.labTestList!.addAll(items);

    notifyListeners();
  }

  addPastMedics(List<BasicListItem> items) {
    presModel.pastMedications = [];
    presModel.pastMedications!.addAll(items);

    notifyListeners();
  }

  setPrescriptionModel(PrescriptionModel data) {
    presModel = PrescriptionModel(drugsList: []);
    presModel = data;
    notifyListeners();
  }

  setBloodGroup(String? item) {
    presModel.bloodGroup = item;

    notifyListeners();
  }

  setIntervalType(String item) {
    selectedIntervalType = item;

    notifyListeners();
  }

  setDrugName(BasicListItem? item) {
    for (var aaa in drugParams!.drugs!) {
      if (aaa.title == item?.item) {
        getIt<OnlineConsultManager>().setUpDrugType(
          Param(title: aaa.drugTypeTitle, id: aaa.drugTypeId),
        );
        getIt<OnlineConsultManager>().setUpDrugUnit(
          Param(title: aaa.drugUnitTitle, id: aaa.drugUnitId),
        );
        break;
      }
    }

    selectedDrug = item;

    notifyListeners();
  }

  setUpDrugType(Param? item) {
    selectedDrugType = item;

    notifyListeners();
  }

  setUpDrugUnit(Param? item) {
    selectedDrugUnit = item;

    notifyListeners();
  }

  setUpDoses(Param item, String doseTime) {
    switch (doseTime) {
      case "M":
        doseM = item;
        break;
      case "A":
        doseA = item;
        break;
      case "E":
        doseE = item;
        break;
      case "N":
        doseN = item;
        break;
    }

    notifyListeners();
  }

  getPatientRequestList() async {
    await Future.delayed(const Duration(milliseconds: 50));
    patientsReqLoader = true;
    notifyListeners();
    String endpoint = Endpoints.patientRequests;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    log("response of getPatientRequestList $responseData");
    if (responseData != null) {
      var result = PatientsRequestsModel.fromJson(responseData);
      patientsReqList = result.patientDetails ?? [];
      for (var element in patientsReqList) {
        if (!patientsReqListId.containsKey(element.id.toString())) {
          patientsReqListId[element.id.toString()] = false;
        }
      }
      // if(patientsReqList.isNotEmpty) {
      // FlutterRingtonePlayer().playRingtone();
      // }else{
      // FlutterRingtonePlayer().stop();

      // }
    }
    patientsReqLoader = false;
    notifyListeners();
  }

  getRecentPatientsList() async {
    String endpoint = Endpoints.recentPatients;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    if (responseData != null) {
      var result = RecentPatientsModel.fromJson(responseData);

      recentPatients = result.recentPatients;
      notifyListeners();
    }
  }

  getConsultations({bool? isRefresh}) async {
    isLoading = true;
    notifyListeners();
    if (consultationsModel == null ||
        (consultationsModel!.currentPage != null &&
            consultationsModel!.next != null) ||
        isRefresh == true) {
      String endpoint = Endpoints.doctorConsultations;

      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      if (consultationsModel?.currentPage == null || isRefresh == true) {
        // docForumsList = [];
        consultationsModel = ConsultaitionsModel(consultations: []);
      }
      await Future.delayed(const Duration(milliseconds: 50));
      paginationLoader = true;
      notifyListeners();
      Map<String, dynamic> data = {
        "page": consultationsModel?.next ?? 1,
        "from_date": consultationsDateIntervals?.startDate != null
            ? getIt<StateManager>().getFormattedforApi(
                consultationsDateIntervals!.startDate!,
              )
            : null,
        "to_date": consultationsDateIntervals?.endDate != null
            ? getIt<StateManager>().getFormattedforApi(
                consultationsDateIntervals!.endDate!,
              )
            : null,
        // "to_from":"05/02/2023"
      };

      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );
      log("response of doctorConsultations $responseData");
      if (responseData != null) {
        var result = ConsultaitionsModel.fromJson(responseData);
        consultationsModel!.next = result.next;
        consultationsModel!.currentPage = result.currentPage;
        consultationsModel!.totalBookingCount = result.totalBookingCount;
        print("consultationsModel!.totalBookingCount");
        print(consultationsModel!.totalBookingCount);
        consultationsModel!.consultations!.addAll(result.consultations ?? []);
      }
      paginationLoader = false;
      isLoading = false;

      notifyListeners();
    }
  }

  getPatientDetails({required int bookingID}) async {
    // if(index==1){
    //   consultations = [];
    // }
    await Future.delayed(const Duration(milliseconds: 50));
    bookingDetailsLoader = true;
    notifyListeners();
    String endpoint = Endpoints.consultationDetails;

    Map<String, dynamic> data = {"booking_id": bookingID};

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var result = PatientDetailsModel.fromJson(responseData);

      patientDetails = result.userDetails;
      bookingDetails = result.bookingDetails;
      bookingDetailsLoader = false;

      notifyListeners();
    }
  }

  getQuestionareAnswers({required int bookingID}) async {
    // if(index==1){
    //   consultations = [];
    // }
    await Future.delayed(const Duration(milliseconds: 50));
    bookingDetailsLoader = true;
    notifyListeners();
    String endpoint = Endpoints.bookingQuestionares;

    Map<String, dynamic> data = {"booking_id": bookingID};

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("response of getQuestionareAnswers $responseData");
    if (responseData != null) {
      var result = QnsAnswersModel.fromJson(responseData);

      questionnaire = result.questionnaire ?? [];
      bookingDetailsLoader = false;

      notifyListeners();
    }
  }

  Future<BasicResponseModel> sendConsultedStatus(int bookingId) async {
    String endpoint = Endpoints.connectScheduleBooking;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {
      "booking_id": bookingId,
      "connection_type": 1,
      "connected_user_type": 2,
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      var res = BasicResponseModel.fromJson(responseData);
      return res;
    } else {
      return BasicResponseModel(status: false, message: "");
    }
  }

  getScheduledBookings(DateTime dt) async {
    String endpoint = Endpoints.scheduledBooking;
    await Future.delayed(const Duration(milliseconds: 50));
    selectedDt = dt;
    scheduledBookloader = true;
    notifyListeners();

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    String formattedDate = DateFormat('dd/MM/yyyy').format(dt);
    Map<String, dynamic> data = {"date": formattedDate};
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    // print("responseData");
    // print(responseData);
    log("response data of scheduledBooking ${responseData.toString()}");
    if (responseData != null) {
      var result = UpcomingBookingsModel.fromJson(responseData);
      upcomingAppointments = result.upcomingAppointments ?? [];
    } else {
      upcomingAppointments = [];
    }

    scheduledBookloader = false;
    notifyListeners();
  }

  Future<AcceptPatientReqModel> acceptPatientRequest(int bookingid) async {
    String endpoint = Endpoints.acceptPatientReq;
    Map<String, dynamic> data = {"booking_request_id": bookingid};
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log("response of acceptPatientRequest $responseData");
    if (responseData != null) {
      var dt = AcceptPatientReqModel.fromJson(responseData);
      presModel.height = dt.patientDetails?.height;
      presModel.weight = dt.patientDetails?.weight;
      presModel.bloodGroup = dt.patientDetails?.bloodGroup;
      presModel.pastMedications =
          dt.patientDetails?.pastMedicationDetails
              ?.map((e) => BasicListItem(id: e.id, item: e.title))
              .toList() ??
          [];
      return dt;

      // notifyListeners();
    } else {
      return AcceptPatientReqModel(status: false, message: "No data");
    }
  }

  Future<BasicResponseModel> rejectPatientCall(int bookingid) async {
    String endpoint = Endpoints.acceptDeclineReq;
    Map<String, dynamic> data = {"booking_request_id": bookingid};
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var dt = BasicResponseModel.fromJson(responseData);
      return dt;

      // notifyListeners();
    } else {
      return BasicResponseModel(status: false, message: "No data");
    }
  }

  getDrugParams() async {
    String endpoint = Endpoints.drugDetails;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    if (responseData != null) {
      var dt = DrugParams.fromJson(responseData);
      if (dt.status == true) {
        drugParams = dt;
        notifyListeners();
      }

      // notifyListeners();
    }
  }

  Future<BasicResponseModel3> savePrescriptionImage(
    int prescriptId,
    File file,
  ) async {
    setPriscriptionLoader(true);

    String filePath = file.path;

    // var res = await MultipartFile.fromFile(
    //   filePath,
    //   filename: "filePath.split('/').last",
    //   // contentType:MediaType.,
    // );

    String endpoint = Endpoints.prescripImageSave;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    final formData = FormData.fromMap({
      "prescription_id": prescriptId,
      "image": await MultipartFile.fromFile(
        filePath,
        filename: "upload.png",
        // contentType:MediaType.,
      ),
    });

    dynamic responseData = await getIt<DioClient>().post(
      endpoint,
      formData,
      tokn,
    );
    setPriscriptionLoader(false);

    if (responseData != null) {
      var resp = BasicResponseModel3.fromJson(responseData);
      return resp;
    } else {
      return BasicResponseModel3(status: true, message: "Failed");
      // return SymptomsAndIssuesModel(status: false);
    }
  }

  Future<File> writeUint8ListToFile(Uint8List data, String filename) async {
    // Get the application's documents directory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Create a file path
    File file = File('$appDocPath/$filename.png');

    // Write the Uint8List to the file
    return await file.writeAsBytes(data);
  }

  void addPatientId(String id, bool value) {
    patientsReqListId[id] = value;
  }

  void setSearchQueryValue(String val) {
    searchQuery = val;
    notifyListeners();
  }
}
