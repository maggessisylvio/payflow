import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playflow/modules/barcode_scanner/barcode_scanner_page.dart';
import 'package:playflow/modules/home/home_page.dart';
import 'package:playflow/modules/insert_boleto/insert_boleto_page.dart';
import 'package:playflow/modules/login/login_page.dart';
import 'package:playflow/modules/splash/splash_page.dart';
import 'package:playflow/shared/models/boleto_model.dart';
import 'package:playflow/shared/models/user_model.dart';
import 'package:playflow/shared/themes/app_colors.dart';
import 'package:playflow/shared/widgets/boleto_list/boleto_list_controller.dart';

class AppWidget extends StatelessWidget {
  AppWidget() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay Flow',
      theme: ThemeData(
          primaryColor: AppColors.primary, primarySwatch: Colors.orange),
      initialRoute: "/splash",
      routes: {
        "/splash": (context) => SplashPage(),
        "/home": (context) => HomePage(
              user: ModalRoute.of(context)!.settings.arguments as UserModel,
            ),
        "/login": (context) => LoginPage(),
        "/barcode_scanner": (context) {
          return BarcodeScannerPage(
            controller: ModalRoute.of(context)!.settings.arguments
                as BoletoListController,
          );
        },
        "/insert_boleto": (context) {
          List<dynamic> args =
              ModalRoute.of(context)!.settings.arguments as List<dynamic>;
          return InsertBoletoPage(
            model: args[0] != null ? args[0] as BoletoModel : BoletoModel(),
            boletoController: args[1] as BoletoListController,
          );
        },
      },
    );
  }
}
