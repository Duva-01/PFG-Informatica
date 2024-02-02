import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grownomics/logins/welcomePage.dart';
import 'package:grownomics/paginas/inicio.dart'; // Asegúrate de tener el import correcto para HomeScreen
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    inicializar();
  }

  void inicializar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;

    Timer(Duration(seconds: 5), () {
      if (isUserLoggedIn) {
        // Si el usuario está "recordado", redirige directamente a HomeScreen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        // Si el usuario no está "recordado", lleva al usuario a WelcomePage
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => WelcomePage(),
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 1000),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // La implementación del widget sigue igual
    return FlipInY(
      child: Container(
        child: Container(
          margin: EdgeInsets.all(20),
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 50,
            height: 50,
            child: LoadingIndicator(
              indicatorType: Indicator.lineScale,
              colors: const [Colors.green],
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("assets/images/grownomics_logo.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
