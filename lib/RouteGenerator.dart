import 'package:flutter/material.dart';
import 'package:transportationapp/DriverOptionsPage.dart';
import 'package:transportationapp/DriverUpcomingOrder.dart';
import 'package:transportationapp/EmiCalculator.dart';
import 'package:transportationapp/FadeTransition.dart';
import 'package:transportationapp/FreightCalculator.dart';
import 'package:transportationapp/HomePage.dart';
import 'package:transportationapp/IntroPageLoginOptions.dart';
import 'package:transportationapp/MyConstants.dart';
import 'package:transportationapp/NewTransportingOrder.dart';
import 'package:transportationapp/OrderSummaryScreen.dart';
import 'package:transportationapp/OwnerOptionsPage.dart';
import 'package:transportationapp/RequestTransport.dart';
import 'package:transportationapp/SplashScreen.dart';
import 'package:transportationapp/TollCalculator.dart';
import 'package:transportationapp/TransporterOptionsPage.dart';
import 'package:transportationapp/TripPlanner.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splashPage:
        return FadeRoute(page: SplashScreen());
      case introLoginOptionPage:
          return FadeRoute(page: IntroPageLoginOptions());
      case ownerOptionPage:
        return FadeRoute(page: OwnerOptionsPage());
      case driverOptionPage:
        return FadeRoute(page: DriverOptionsPage());
      case transporterOptionPage:
        return FadeRoute(page: TransporterOptionsPage());
      case emiCalculatorPage:
        return FadeRoute(page: EmiCalculator());
      case freightCalculatorPage:
        return FadeRoute(page: FreightCalculator());
      case tollCalculatorPage:
        return FadeRoute(page: TollCalculator());
      case tripPlannerPage:
        return FadeRoute(page: TripPlanner());
      case homePage:
        return FadeRoute(page: HomePage(userDriver: args,));
      case driverUpcomingOrderPage:
        return FadeRoute(page: DriverUpcomingOrder());
      case newTransportingOrderPage:
        return FadeRoute(page: NewTransportingOrder());
      case orderSummaryPage:
        return FadeRoute(page: OrderSummaryScreen());
      case requestTransportPage:
        return FadeRoute(page: RequestTransport());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}