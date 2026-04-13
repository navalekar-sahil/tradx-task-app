import 'package:flutter/material.dart';
import 'package:trade_x_lite/model/stock_model.dart';
import 'package:trade_x_lite/utils/routes_name.dart';
import 'package:trade_x_lite/view/auth/login_screen.dart';

import '../view/home_screen.dart';
import '../view/auth/splash_splash_screen.dart';
import '../view/stock_details_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) =>  SplashScreen(),
        );

      case RoutesName.loginScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        );

      case RoutesName.homeScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        );

      case RoutesName.stockDetailScreen:
        final args = settings.arguments as Map<String, dynamic>;
          final StockModel stock = args['stock'];
        return MaterialPageRoute(
          builder: (BuildContext context) =>  StockDetailScreen(stock: stock,),
        );

      default:
        return _errorRoute("No route defined for ${settings.name}");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
