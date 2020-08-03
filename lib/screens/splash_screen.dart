import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marcacao_consulta_medico/config/transition.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
    Future.delayed(Duration(seconds: 4)).then((_){
      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(125),
            child: Image.asset("images/logo.png"),
          )
        ],
      ),
    );
  }
}
