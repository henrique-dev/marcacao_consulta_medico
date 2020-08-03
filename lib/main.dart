import 'package:flutter/material.dart';
import 'package:marcacao_consulta_medico/screens/splash_screen.dart';

import 'config.dart';

void main() {
  runApp(
      MaterialApp(
        //routes: Config.routes,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      )
  );
}