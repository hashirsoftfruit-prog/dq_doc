import 'dart:developer';

import 'package:dqueuedoc/controller/managers/state_manager.dart';
import 'package:dqueuedoc/model/core/basic_response_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/analytics_model.dart';
import '../../model/core/revenue_screen_model.dart';
import '../../model/core/settlement_history_model.dart';
import '../../model/helper/service_locator.dart';
import '../../view/theme/constants.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

class SettlementsManager extends ChangeNotifier {
  AnalyticsModel? analyticsModel;
  RevenueModel? revenueModel;
  DateIntervals? dateInterval;
  List<Settlements>? settlements;
  bool settlementLoader = false;
  List<String> selectedGraphDay = [];

  selectGraphItem({required String date, required String count}) {
    selectedGraphDay = [date, count];
    notifyListeners();
  }

  doctorWeeklySettles({DateTime? startDate, DateTime? endDate}) async {
    String endpoint = Endpoints.weeklySettlement;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    DateTime today = DateTime.now();
    DateTime startDay = startDate ?? today.subtract(const Duration(days: 7));

    DateTime endDay = endDate ?? today.subtract(const Duration(days: 1));

    dateInterval = DateIntervals(startDate: startDay, endDate: endDay);

    Map<String, dynamic> data = {
      "start_date": getIt<StateManager>().getFormattedforApi(startDay),
      "end_date": getIt<StateManager>().getFormattedforApi(endDay)
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log(responseData.toString());
    if (responseData != null) {
      var result = AnalyticsModel.fromJson(responseData);
      analyticsModel = result;
      // recentPatients  = result.recentPatients;
      selectedGraphDay = [];
      notifyListeners();
    }
  }

  Future<RevenueModel> getRevenueWithdrawal(
      {required DateTime startDate, required DateTime endDate}) async {
    String endpoint = Endpoints.revenueWithdrawal;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    // DateTime today = DateTime.now();
    // DateTime startOfWeek = startDate??today.subtract(Duration(days: today.weekday - DateTime.monday));
    // DateTime endOfWeek =endDate?? today.add(Duration(days: DateTime.sunday - today.weekday));
    // dateInterval = DateIntervals(startDate: startOfWeek, endDate: endOfWeek);

    Map<String, dynamic> data = {
      "start_date": getIt<StateManager>().getFormattedforApi(startDate),
      "end_date": getIt<StateManager>().getFormattedforApi(endDate)
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var result = RevenueModel.fromJson(responseData);
      return result;
    } else {
      return RevenueModel(
          status: false, message: "No Data", patientDetails: null);
    }
  }

  Future<BasicResponseModel> requestWithdrawal(
      {required DateTime startDate,
      required DateTime endDate,
      required String note,
      required String revenue}) async {
    String endpoint = Endpoints.settlementRequest;

    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "start_date": getIt<StateManager>().getFormattedforApi(startDate),
      "end_date": getIt<StateManager>().getFormattedforApi(endDate),
      "doctor_revenue": double.tryParse(revenue),
      "doctor_note": note
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var result = BasicResponseModel.fromJson(responseData);
      return result;
    } else {
      return BasicResponseModel(status: false, message: "");
    }
  }

  getSettlemntHistory({required int index}) async {
    String endpoint = Endpoints.settlmentHistory;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    if (index == 1) {
      settlements = [];
    }
    settlementLoader = true;
    notifyListeners();

    Map<String, dynamic> data = {
      "page": index,
      // "type" :"Previous"
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null) {
      var result = SettlementHistoryModel.fromJson(responseData);
      settlements!.addAll(result.settlements ??
          [
            // Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //     settledDate:'2024-08-14',
            //     totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
            //         Settlements(startDate:"2024-08-14",endDate: '2024-08-15',
            //           settledDate:'2024-08-14',
            //           totalAmountPaid:'342',),
          ]);
    }
    // else {
    //   return SettlementHistoryModel(status: false);
    // }
    settlementLoader = false;
    notifyListeners();
  }
}
