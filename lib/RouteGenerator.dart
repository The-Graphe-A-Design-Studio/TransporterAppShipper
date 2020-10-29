import 'package:flutter/material.dart';
import 'package:shipperapp/CommonPages/FadeTransition.dart';
import 'package:shipperapp/MyConstants.dart';
import 'package:shipperapp/SplashScreen.dart';
import 'package:shipperapp/TransporterPages/HomePageTransporter.dart';
import 'package:shipperapp/TransporterPages/HomePageTransporterNotVerified.dart';
import 'package:shipperapp/TransporterPages/MyDeliveryPage.dart';
import 'package:shipperapp/TransporterPages/OrderSummaryScreen.dart';
import 'package:shipperapp/TransporterPages/PostLoad.dart';
import 'package:shipperapp/TransporterPages/RequestTransport.dart';
import 'package:shipperapp/TransporterPages/SubscriptionPage.dart';
import 'package:shipperapp/TransporterPages/TransporterOptionsPage.dart';
import 'package:shipperapp/TransporterPages/UploadDocsTransporter.dart';
import 'package:shipperapp/TransporterPages/ViewBidsPerLoadScreen.dart';
import 'package:shipperapp/TransporterPages/ViewLoadsScreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      //Basic Pages
      case splashPage:
        return FadeRoute(page: SplashScreen());

      case transporterOptionPage:
        return FadeRoute(page: TransporterOptionsPage());

      //Pages once the user is LoggedIn - Transporter
      case homePageTransporter:
        return FadeRoute(
          page: HomePageTransporter(
            userTransporter: args,
          ),
        );
      case homePageTransporterNotVerified:
        return FadeRoute(
          page: HomePageTransporterNotVerified(
            userTransporter: args,
          ),
        );
      case uploadDocsTransporter:
        return FadeRoute(
          page: UploadDocs(
            userTransporter: (args as Map)['user'],
            startFrom: (args as Map)['passValue'],
          ),
        );
      case orderSummaryPage:
        return FadeRoute(page: OrderSummaryScreen());
      case requestTransportPage:
        return FadeRoute(page: RequestTransport());
      case postLoad:
        return FadeRoute(
          page: PostLoad(
            userTransporter: args,
          ),
        );
      case subscription:
        return FadeRoute(
            page: SubsriptionPage(
          userTransporter: args,
        ));

      case viewLoads:
        return FadeRoute(
            page: ViewLoadsScreen(
          activeLoads: (args as List)[0],
          inactiveLoads: (args as List)[1],
        ));

      case viewBids:
        return FadeRoute(
            page: ViewBidsPerLoadScreen(
          load: args,
        ));
      case myDel:
        return FadeRoute(page: MyDeliveryPage(user: args));

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
