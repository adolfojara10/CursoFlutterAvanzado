import 'package:flutter/material.dart';

import '../../place/model/place.dart';

class UserF {
  final String uid;
  final String username;
  final String email;
  final String photoURL;
  final List<Place> myFavoritePlaces;
  final List<Place> myPlaces;

  UserF(
      {Key key,
      @required this.uid,
      @required this.username,
      @required this.email,
      @required this.photoURL,
      this.myFavoritePlaces,
      this.myPlaces});
}
