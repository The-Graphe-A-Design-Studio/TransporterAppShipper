import 'package:flutter/material.dart';
import 'package:shipperapp/CommonPages/EmiCalculator.dart';
import 'package:shipperapp/CommonPages/FadeTransition.dart';
import 'package:shipperapp/CommonPages/FreightCalculator.dart';
import 'package:shipperapp/CommonPages/IntroPageLoginOptions.dart';
import 'package:shipperapp/CommonPages/TollCalculator.dart';
import 'package:shipperapp/CommonPages/TripPlanner.dart';
import 'package:shipperapp/MyConstants.dart';
import 'package:shipperapp/SplashScreen.dart';
import 'package:shipperapp/TransporterPages/HomePageTransporter.dart';
import 'package:shipperapp/TransporterPages/OrderSummaryScreen.dart';
import 'package:shipperapp/TransporterPages/PostLoad.dart';
import 'package:shipperapp/TransporterPages/RequestTransport.dart';
import 'package:shipperapp/TransporterPages/TransporterOptionsPage.dart';
import 'package:shipperapp/TransporterPages/UploadDocsTransporter.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      //Basic Pages
      case splashPage:
        return FadeRoute(page: SplashScreen());

      //Login or Signup Pages
      case introLoginOptionPage:
        return FadeRoute(page: IntroPageLoginOptions());
      case transporterOptionPage:
        return FadeRoute(page: TransporterOptionsPage());

    //Pages which don't need LoggedIn User
      case emiCalculatorPage:
        return FadeRoute(page: EmiCalculator());
      case freightCalculatorPage:
        return FadeRoute(page: FreightCalculator());
      case tollCalculatorPage:
        return FadeRoute(page: TollCalculator());
      case tripPlannerPage:
        return FadeRoute(page: TripPlanner());

    //Pages once the user is LoggedIn - Transporter
      case homePageTransporter:
        return FadeRoute(page: HomePageTransporter(userTransporter: args,));
      case uploadDocsTransporter:
        return FadeRoute(page: UploadDocs(userTransporter: (args as Map)['user'], startFrom: (args as Map)['passValue'],));
      case orderSummaryPage:
        return FadeRoute(page: OrderSummaryScreen());
      case requestTransportPage:
        return FadeRoute(page: RequestTransport());
      case postLoad:
        return FadeRoute(page: PostLoad());

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
