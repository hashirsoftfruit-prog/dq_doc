


import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/managers/auth_manager.dart';
import '../../controller/managers/chat_manager.dart';
import '../../controller/managers/home_manager.dart';
import '../../controller/managers/online_consult_manager.dart';
import '../../controller/managers/settlements_manager.dart';
import '../../controller/managers/state_manager.dart';
import '../../controller/services/dio_service.dart';
import '../../view/theme/widgets.dart';

final getIt = GetIt.instance;


Future <void> setupServiceLocator() async{

  // getIt.registerSingleton<StateManager>(StateManager());
  // void setLocator() {
    getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  // }
    getIt.registerSingleton<OnlineConsultManager>(OnlineConsultManager());
    getIt.registerSingleton<DioClient>(DioClient());
  getIt.registerSingleton<StateManager>(StateManager());
  getIt.registerSingleton<AuthManager>(AuthManager());
  getIt.registerSingleton<SmallWidgets>(SmallWidgets());
  getIt.registerSingleton<SettlementsManager>(SettlementsManager());
  getIt.registerSingleton<HomeManager>(HomeManager());
  getIt.registerSingleton<ChatProvider>(ChatProvider());

    getIt.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());

}


class NavigationService {
  final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();
  dynamic pushTo(String route, {dynamic arguments}) {
    return navigatorkey.currentState?.pushNamed(route, arguments: arguments);
  }

  dynamic goBack() {
    return navigatorkey.currentState?.pop();
  }
}