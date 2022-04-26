import 'package:flutter/material.dart';
import 'package:platzi_trips_app/widgets/gradient_back.dart';
import 'package:platzi_trips_app/widgets/button_green.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignIn();
  }
}

class _SignIn extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return signInGoogleUI();
  }

  Widget signInGoogleUI() {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: <Widget>[
        GradientBack("", null),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text("Welcome \n This is your Travel app",
              style: TextStyle(
                  fontSize: 37,
                  fontFamily: "Lato",
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),

          ButtonGreens(text: "Login with Gmail", 
            onPressed: (),
            width:300.0,
            height:50.0)
        ])
      ]),
    );
  }
}
