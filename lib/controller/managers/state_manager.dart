import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../model/core/basic_response_model.dart';

class StateManager extends ChangeNotifier {
// bool startAnimation = false;
  bool showPass = false;
// int consultTabIndex=1;
  bool isShowChat = true;
  int btmNavIndex = 2;
// bool tempIconViewStatus = true;
  int onlineStatus = 1;
  bool inCallStatus = false;
  bool inChatStatus = false;
  bool showCallEnded = false;
  bool recordingStatus = false;

  bool sheetOpenStatus = false;

  bool isSoundNotificationEnabled = false;

// setAnimation(bool val){
//  startAnimation = val;
//  notifyListeners();
// }
  List<BasicListItem> addedItems = [];
  List<BasicListItem> listItems = [];

  String searchQuery = '';

  // bool getSoundNotificaitonEnabled() {
  //   isSoundNotificationEnabled = getIt<SharedPreferences>()
  //           .getBool(StringConstants.soundNotificationEnabled) ??
  //       false;
  //   notifyListeners();
  //   return isSoundNotificationEnabled;
  // }

  // setSoundNotificationEnabled(bool val) async {
  //   getIt<SharedPreferences>()
  //       .setBool(StringConstants.soundNotificationEnabled, val);
  //   isSoundNotificationEnabled = val;
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool(StringConstants.soundNotificationEnabled, val);

  //   notifyListeners();
  // }

  addItems(List<BasicListItem> vals, {bool? isRefresh}) {
    if (isRefresh == true) {
      addedItems = [];
    }
    addedItems.addAll(vals);
    notifyListeners();
  }

  setListItems(List<BasicListItem> vals, {bool? isRefresh}) {
    if (isRefresh == true) {
      listItems = [];
    }
    listItems = vals;
    notifyListeners();
  }

  setSearchQueryValue(String val, {bool? isDispose}) {
    searchQuery = val;
    if (isDispose != true) {
      notifyListeners();
    }
  }

  removeFromAddedItems(BasicListItem val) {
    addedItems.remove(val);
    notifyListeners();
  }

  logoutFn() {
    btmNavIndex = 2;
    isShowChat = true;
  }

  changeHomeIndex(int val) {
    btmNavIndex = val;
    // print('111111111111111111111111111111111');
    notifyListeners();
  }

  setInCallStatus(bool val) {
    inCallStatus = val;
    // notifyListeners();
  }

  setRecordingStatus(bool val) {
    recordingStatus = val;
    notifyListeners();
  }

  bool getRecordingStatus() {
    return recordingStatus;
  }

  String generateRandomString() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  bool getInCallStatus() {
    return inCallStatus;
  }

  bool getInChatStatus() {
    return inChatStatus;
  }

  setInChatStatus(bool val) {
    inChatStatus = val;
    // notifyListeners();
  }

  setSheetOpenStatus(bool status) {
    sheetOpenStatus = status;
  }

  bool getSheetOpenStatus() {
    return sheetOpenStatus;
  }

  String getDayLabel(int days) {
    if (days == 1) {
      return '$days day';
    } else if (days > 1 && days < 7) {
      return '$days days';
    } else if (days == 7) {
      return '1 week';
    } else if (days == 14) {
      return '2 weeks';
    } else if (days == 30) {
      return '1 month';
    } else if (days == 60) {
      return '2 months';
    } else if (days == 180) {
      return '6 months';
    } else if (days == 365) {
      return '1 year';
    } else {
      return '$days days'; // fallback for any other values
    }
  }

  setOnlineAvailablity(int index) {
    onlineStatus = index;
    notifyListeners();
  }

  showPwd(bool val) {
    showPass = val;
    notifyListeners();
  }

// dispose animationVariable

  String? validateFieldValues(String val, String type) {
    switch (type) {
      case "int":
        return int.tryParse(val) == null ? "Invalid input" : null;
      // break;
      case "double":
        return double.tryParse(val) == null ? "Invalid input" : null;
      case "height":
        return double.tryParse(val) == null || double.parse(val) > 220
            ? "Invalid input"
            : null;
      case "weight":
        return double.tryParse(val) == null || double.parse(val) > 999
            ? "Invalid input"
            : null;
      case "char":
        return null;
      case "bloodGroup":
        return isValidBloodGroup(val) == false ? "Invalid input" : null;
      case "bloodPressure":
        return isValidBloodPressure(val) == false ? "Invalid input" : null;
      default:
        return null;
    }
  }

  String convertTime(String input) {
    // Split the input string by colon
    List<String> parts = input.split(':');

    // Extract hours, minutes, and seconds
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    // int seconds = int.parse(parts[2]); // We won't use seconds in the output

    // Determine the period (AM/PM) and convert hours to 12-hour format
    String period = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    if (hours == 0) {
      hours = 12; // 12 AM or 12 PM
    }

    // Format the output string
    String formattedTime =
        '${hours.toString().padLeft(2, '0')}.${minutes.toString().padLeft(2, '0')} $period';

    return formattedTime;
  }

  bool isValidBloodGroup(String bloodGroup) {
    // Regular expression pattern for blood groups (e.g., A+, AB-, etc.)
    RegExp regex = RegExp(r'^[ABO][+-]$');

    // Check if the entered blood group matches the pattern
    if (regex.hasMatch(bloodGroup)) {
      return true;
    } else {
      return false;
    }
  }

  String buildAddress(List<String?> addressParts) {
    return addressParts
        .where((part) => part != null && part.trim().isNotEmpty)
        .join(', ');
  }

  bool isValidBloodPressure(String bp) {
    // Regular expression pattern for blood groups (e.g., A+, AB-, etc.)
    // RegExp regex = RegExp(r'^[ABO][+-]$');
    List<String> bpParts = bp.split('/');
    if (bpParts.length == 2 &&
        double.tryParse(bpParts[0]) != null &&
        double.tryParse(bpParts[1]) != null) {
      return true;
    } else {
      return false;
    }
    // onImageError(){
    //   imgError = true;
    //   notifyListeners();
    // }

    // removeLastIfZero(String str){
    //   if (str != null && str.length > 0 ) {
    //
    //     var st = str.substring(str.length-1);
    //     if(st == "0"){
    //       str = str.substring(0, str.length - 1);
    //
    //     }
    //   }
    //   return str;
    // }

    // Future<bool> checkInternetConnection() async {
    //  var connectivityResult = await Connectivity().checkConnectivity();
    //  return connectivityResult != ConnectivityResult.none;
    // }
  }

  getFormattedDate(String dt) {
    DateTime date = DateTime.parse(dt);
    // Format the date using intl package
    String formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate;
  }

  getFormattedDate2(String dt) {
    DateTime date = DateTime.parse(dt);
    // Format the date using intl package
    String formattedDate = DateFormat('MMMd').format(date);
    return formattedDate;
  }

  getFormattedDate3(String? dt) {
    if (dt != null) {
      DateTime date = DateTime.parse(dt);
      // Format the date using intl package
      String formattedDate = DateFormat("MMM d, yyyy").format(date);
      return formattedDate;
    } else {
      return null;
    }
  }

  getFormattedforApi(DateTime dt) {
    // Format the date using intl package
    String formattedDate = DateFormat('dd/MM/yyyy').format(dt);
    return formattedDate;
  }

  getMonthDay(DateTime dt) {
    // Format the date using intl package
    String formattedDate = DateFormat.MMMd().format(dt);
    return formattedDate;
  }

  getMonthDayFromString(String dt) {
    // Format the date using intl package
    DateTime dateTime = stringToDateTime(dt);
    String formattedDate = DateFormat.MMMd().format(dateTime);
    return formattedDate;
  }

  getTimeFromDTime(DateTime dt) {
    // Format the date using intl package
    String formattedDate = DateFormat.jm().format(dt);
    return formattedDate;
  }

  stringToDateTime(String dt) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime dateTime = dateFormat.parse(dt);

    return dateTime;
  }

  stringToTime(String? timeInput) {
    if (timeInput != null) {
      DateTime parsedTime = DateFormat("HH:mm:ss").parse(timeInput);
      String formattedTime = DateFormat("hh:mm a").format(parsedTime);
      return formattedTime;
    } else {
      return null;
    }
  }

  // getMonthDayFromString2(String dt){
  //  // Format the date using intl package
  //  DateTime dateTime  =stringToDateTime2(dt);
  //  String formattedDate = DateFormat.MMMd().format(dateTime);
  //  return formattedDate;
  // }
  //
  // stringToDateTime2(String dt){
  //  DateFormat dateFormat = DateFormat.yMd();
  //  DateTime dateTime = dateFormat.parse(dt);
  //
  //  return dateTime;
  // }

  disposeConsultLanding() {
    isShowChat = true;
  }

  setCallEndedStatus() async {
    showCallEnded = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    showCallEnded = false;
    notifyListeners();
  }

  updateHomeIndex({bool? val}) {
    // print("btmNavIndex changd to $val");
    // consultTabIndex = consultTabIndex==0?1:0;
    if (val == null) {
      isShowChat = !isShowChat;
    } else {
      isShowChat = val;
    }
    notifyListeners();
  }

  String capitalizeFirstLetter(String s) {
    if (s.isEmpty) {
      return s;
    }
    return s[0].toUpperCase() + s.substring(1);
  }

  getFormattedTime(String time) {
    DateFormat inputFormat = DateFormat("HH:mm:ss");
    DateFormat outputFormat = DateFormat("hh:mm a");
    DateTime dateTime = inputFormat.parse(time);
    String formattedTime = outputFormat.format(dateTime);
    return formattedTime;
  }

  String dateTimeToLabels(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Calculate date differences
    final differenceInDays = today.difference(dateTime).inDays;

    if (differenceInDays == 0) {
      return "Today";
    } else if (differenceInDays == 1) {
      return "Yesterday";
      // } else if (differenceInDays <= 7) {
      //  return "$differenceInDays Days";
    } else if (differenceInDays <= 14) {
      return differenceInDays <= 7 ? "1w ago" : "2w ago";
      // } else if (dateTime.month == now.month && dateTime.year == now.year) {
      //  return "This Month";
    } else {
      return DateFormat("MMM dd, yyyy").format(dateTime);
    }
  }
}
