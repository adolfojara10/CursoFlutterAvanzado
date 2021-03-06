// ignore_for_file: missing_required_param

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/place/model/place.dart';
import 'package:platzi_trips_app/place/ui/widgets/card_image.dart';

import '../../../user/bloc/bloc_user.dart';
import '../../../widgets/button_purple.dart';
import '../../../widgets/gradient_back.dart';
import '../../../widgets/text_input.dart';
import '../../../widgets/title_header.dart';
import '../widgets/title_input_location.dart';

class AppPlaceScreen extends StatefulWidget {
  File image;

  AppPlaceScreen({Key key, this.image});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _AppPlaceScreen extends State<AppPlaceScreen> {
  final _controllerTitlePlace = TextEditingController();
  final _controllerDescriptionPlace = TextEditingController();
  final _controllerLocationPlace = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of(context);
    return Scaffold(
      body: Stack(children: <Widget>[
        GradientBack(height: 300.0),
        Row(children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 25.0, left: 25.0),
            child: SizedBox(
                height: 45.0,
                width: 45.0,
                child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_left,
                        color: Colors.white, size: 45.0),
                    onPressed: () {
                      //para volver a la anterior pantalla, las screen en flutter estan en forma
                      // de stack
                      Navigator.pop(context);
                    })),
          ),
          Flexible(
              child: Container(
                  //width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 10.0),
                  child: TitleHeader(title: "Add a new Place")))
        ]),
        Container(
            margin: EdgeInsets.only(top: 120.0, bottom: 20.0),
            child: ListView(children: <Widget>[
              //foto
              Container(
                alignment: Alignment.center,
                child: CardImageWithFabICON(
                  pathImage: widget.image.path,
                  height: 350.0,
                  width: 250.0,
                  iconData: Icons.camera,
                  left: 0.0,
                ),
              ),
              //Titulo
              Container(
                  margin: EdgeInsets.only(top: 22.0, bottom: 20.0),
                  child: TextInput(
                      hintText: "Title",
                      inputType: null,
                      maxLines: 1,
                      controller: _controllerTitlePlace)),
              //descripcion
              TextInput(
                  hintText: "Description",
                  inputType: TextInputType.multiline,
                  maxLines: 4,
                  controller: _controllerDescriptionPlace),
              //location
              Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextInputLocation(
                      hintText: "Location",
                      iconData: Icons.location_on_outlined,
                      controller: _controllerLocationPlace)),

              //add place button
              Container(
                  width: 70.0,
                  child: ButtonPurple(
                      buttonText: "Add Place",
                      onPressed: () {
                        //id del usuario logeado
                        userBloc.currentUser().then((User user) async {
                          if (user != null) {
                            String uid = user.uid;
                            String path =
                                "${uid}/${DateTime.now().toString()}.jpg";
                            //1. firebase storage
                            //url
                            // ignore: sdk_version_set_literal
                            userBloc
                                .uploadFile(path, widget.image)
                                .then((UploadTask storageUploadTask) {
                              storageUploadTask
                                  .whenComplete(() => null)
                                  .then((TaskSnapshot snapshot) {
                                snapshot.ref.getDownloadURL().then((urlImage) {
                                  print("URLIMAGE: ${urlImage}");

                                  //2. cloud firestore
                                  userBloc
                                      .updatePlaceDate(Place(
                                          name: _controllerTitlePlace.text,
                                          description:
                                              _controllerDescriptionPlace.text,
                                          likes: 0

                                          // ignore: sdk_version_set_literal
                                          ))
                                      .whenComplete(() {
                                    print("TERMINOOO");
                                    Navigator.pop(context);
                                  });
                                });
                              });
                            });
                          }
                        });
                      }))
            ]))
      ]),
    );
  }
}
