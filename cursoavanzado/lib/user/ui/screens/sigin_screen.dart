import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platzi_trips_app/widgets/gradient_back.dart';
import 'package:platzi_trips_app/widgets/button_green.dart';
import 'package:platzi_trips_app/user/bloc/bloc_user.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/platzi_trips_cupertino.dart';

import '../../model/user.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignIn();
  }
}

class _SignIn extends State<SignIn> {
  UserBloc userBloc;
  double screenwidth;

  @override
  Widget build(BuildContext context) {
    //se instancia el objeto, el context es lo que indica el ciclo de vida de la app
    //es decir se va cuando se cierra la app. Es patron singleton
    userBloc = BlocProvider.of(context);
    screenwidth = MediaQuery.of(context).size.width;
    return _handleCurrentSession();
  }

  Widget _handleCurrentSession() {
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //snapshot contiene los datos del usuario desde el firebase
        if (!snapshot.hasData || snapshot.hasError) {
          return signInGoogleUI();
        } else {
          return PlatziTripsCupertino();
        }
      },
    );
  }

  Widget signInGoogleUI() {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: <Widget>[
        GradientBack(height: null),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Flexible(
              child: Container(
                  width: screenwidth -
                      (screenwidth /
                          14), //hago esta resta para colocarle margenes horizontales y ademas simular diferentes width de pantallas
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Welcome \n This is your Travel App',
                      style: TextStyle(
                          fontFamily: 'lato',
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ))),
          ButtonGreens(
              text: "Login with Gmail",
              onPressed: () {
                userBloc.signOut();
                userBloc.signIn().then((UserCredential user) {
                  userBloc.updateUserData(UserF(
                    uid: user.user.uid,
                    email: user.user.email,
                    username: user.user.displayName,
                    photoURL: user.user.photoURL,
                  ));
                });
              },
              width: 300.0,
              height: 50.0)
        ])
      ]),
    );
  }
}
