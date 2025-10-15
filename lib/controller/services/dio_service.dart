import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/helper/service_locator.dart';
import '../../view/theme/constants.dart';
import '../../view/ui/starting_screens/login_screen.dart';
import 'api_endpoints.dart';

class DioClient {
  // String baseUrl = "http://159.65.150.176/edumartial/public/api/";
  // String baseUrl = "http://143.198.147.88/edumartial/public/api/";
  // String baseUrl = "http://143.198.147.88/edumartial-app/public/api/";
  String baseUrl = '${StringConstants.baseUrl}/api/';

  post(String endpoint, var data, String? token) async {
    String url = "$baseUrl$endpoint";
    print(url);
    print(data);
    var dio = Dio();
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    try {
      if (token == null) {
        Response response = await dio.post(url, data: data);
        log(response.statusCode.toString());
        if (response.statusCode == 200) {
          return response.data;
        } else {
          return null;
        }
      }
      Response response = await dio.post(
        url,
        // data: {"username": username, "password": password, "email": email},
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Doctor-Id':
                getIt<SharedPreferences>().getInt(StringConstants.userId) ?? "",
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        // Access the response's status code
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 && endpoint == Endpoints.scheduledBooking ||
            endpoint == Endpoints.doctorProfile) {
          // await getIt<HomeManager>().log(isForceLogout: true);
          Fluttertoast.showToast(msg: "Unauthorized User");
          Navigator.pushAndRemoveUntil(
            getIt<NavigationService>().navigatorkey.currentContext!,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      } else {
        // Handle other exceptions
        if (kDebugMode) {
          print('Error: $e');
        }
      }

      return null;
    }
  }

  get(String endpoint, String? token) async {
    String url = "$baseUrl$endpoint";

    if (kDebugMode) {
      print("url: $url");
      print("token: $token");
    }
    var dio = Dio();
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    try {
      if (token == null) {
        Response response = await dio.get(url);

        if (response.statusCode == 200) {
          return response.data;
        } else {
          return null;
        }
      }
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Doctor-Id':
                getIt<SharedPreferences>().getInt(StringConstants.userId) ?? "",

            // 'Accept-Language':getIt<SharedPreferences>().getString(StringConstants.language)??"en"
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("error is from dio ${e.message}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("error is $e");
      }
    }
  }

  // Future <List<Map<String,dynamic>>> get(url)async{
  // Future <dynamic> get( String url)async{
  //   var dio = Dio();
  //   try{
  //     Response response = await dio.get(
  //      url,
  //
  //     );
  //     return response.data;
  //   }
  //   catch(e){
  //     print(e);
  //   }
  //
  // }
}

//
//
// import 'package:dio/dio.dart';
// import 'package:finprov/models/core/auth_model.dart';
// import 'package:finprov/models/core/posts_model.dart';
//
//
// class DioClient{
//   final String baseUrl="http://staging.finprov.com/wp-json";
//
//
//   Future<User?> authUser({required String email,required String password}) async{
//     User? retrievedUser;
//
//     try{
//       var dio = Dio();
//       final _baseUrl = baseUrl;
//        Response response = await dio.post(
//         _baseUrl + "/jwt-auth/v1/token/",
//         data: {"username":email ,"password":password},
//       );
//       // data: {"username":"finprov_admin","password":"Finprov_admin@2022"}
//       print(response.data);
//
//       Map<String,dynamic> jsonData = response.data;//jsonDecode(response.data);
//
//       retrievedUser = User.fromJson(jsonData);
//
//       return retrievedUser;
//       // if(retrievedUser!=null) {
//       //
//       //
//       //   print('User created: ${response.data}');
//       // }
//
//
//     }
//     catch(e){
//       print('Error creating user: $e');
//     }
//   }
//
//
//   registerUser({required String email,required String username,required String password})async{
//
//     try{
//       var dio = Dio();
//       final _baseUrl = baseUrl;
//       String token ="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9zdGFnaW5nLmZpbnByb3YuY29tIiwiaWF0IjoxNjUwNDQzOTgyLCJuYmYiOjE2NTA0NDM5ODIsImV4cCI6MTY1MTA0ODc4MiwiZGF0YSI6eyJ1c2VyIjp7ImlkIjoiMSJ9fX0.vu0-A5AODc6OM6P58H1i25zXLLKlQAXNQtYhRQUXVFw";
//       Response response = await dio.post(
//         _baseUrl + "/wp/v2/users",
//         data: {"username":username ,"password":password,"email":email},
//         options:Options(headers: {'Authorization': 'Bearer $token'})
//       );
//
//       print(response.data);
//
//       Map<String,dynamic> jsonData = response.data;//jsonDecode(response.data);
//
//
//
//
//
//     }
//     catch(e){
//       print('Error creating user: $e');
//     }
//   }
//
//
//
//
//
//
//   Future <List<Posts>?> getPosts() async{
//     try{
//       var dio = Dio();
//       final _baseUrl = baseUrl;
//       Response response = await dio.get(
//         _baseUrl + "/wp/v2/posts?_fields=author,id,excerpt,title,link",
//       );
//
//       List<Posts> record = [];
//       for (var element in response.data) {
//         record.add(Posts.fromJson(element));
//       }
//
//       return record;
//     }
//     catch(e){
//       print('error $e');
//     }
//
//
//   }
//
//
// }
//
