import 'package:flutter/material.dart';
import 'package:transportationapp/DriverPages/DriverUpcomingOrder.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/DriverPages/DriverOptionsPage.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/CommonPages/EmiCalculator.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/CommonPages/FadeTransition.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/CommonPages/FreightCalculator.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/DriverPages/HomePageDriver.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/OwnerPages/HomePageOwner.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/CommonPages/IntroPageLoginOptions.dart';
import 'package:transportationapp/MyConstants.dart';
import 'package:transportationapp/OwnerPages/AddTruckFromOwner.dart';
import 'package:transportationapp/OwnerPages/EditTruckFromOwner.dart';
import 'package:transportationapp/OwnerPages/ViewProfileOwner.dart';
import 'package:transportationapp/OwnerPages/ViewTrucksOwner.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/TransporterPages/NewTransportingOrder.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/TransporterPages/OrderSummaryScreen.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/OwnerPages/OwnerOptionsPage.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/TransporterPages/RequestTransport.dart';
import 'package:transportationapp/SplashScreen.dart';
import 'package:transportationapp/TransporterPages/Company/EditProfileCompany.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/CommonPages/TollCalculator.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/TransporterPages/TransporterOptionsPage.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/CommonPages/TripPlanner.dart';
import 'package:transportationapp/TransporterPages/Company/HomePageCompany.dart';
import 'package:transportationapp/TransporterPages/Individual/EditProfileIndividual.dart';
import 'package:transportationapp/TransporterPages/Individual/HomePageIndividual.dart';

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
      case ownerOptionPage:
        return FadeRoute(page: OwnerOptionsPage());
      case driverOptionPage:
        return FadeRoute(page: DriverOptionsPage());
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

    //Pages once the user is LoggedIn - Driver
      case homePageDriver:
        return FadeRoute(page: HomePageDriver(userDriver: args));
      case driverUpcomingOrderPage:
        return FadeRoute(page: DriverUpcomingOrder());

    //Pages once the user is LoggedIn - Transporter
      case homePageTransporterCompany:
        return FadeRoute(page: HomePageCompany());
      case homePageTransporterIndividual:
        return FadeRoute(page: HomePageIndividual());
      case editProfileCompany:
        return FadeRoute(page: EditProfileCompany());
      case editProfileIndividual:
        return FadeRoute(page: EditProfileIndividual());
      case newTransportingOrderPage:
        return FadeRoute(page: NewTransportingOrder());
      case orderSummaryPage:
        return FadeRoute(page: OrderSummaryScreen());
      case requestTransportPage:
        return FadeRoute(page: RequestTransport());

    //Pages once the user is LoggedIn - Owner
      case homePageOwner:
        return FadeRoute(page: HomePageOwner(userOwner: args));
      case addTruckOwner:
        return FadeRoute(page: AddTruckOwner(userOwner: args));
      case viewTrucksOwner:
        return FadeRoute(
            page: ViewTrucksOwner(
          userOwner: args,
        ));
      case editTrucksOwner:
        return FadeRoute(
            page: EditTruckOwner(
                truck: (args as Map)["truck"],
                viewTrucksOwnerState: (args as Map)["state"]));
      case viewProfileOwner:
        return FadeRoute(
            page: ViewProfileOwner(
          userOwner: args,
        ));

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
