import 'package:flutter/material.dart';

import '../../user/model/user.dart';

class Place {
  String id;
  String name;
  String description;
  String uriImage;
  int likes;
  bool liked;
  //UserF userOwner;

  Place(
      {Key key,
      @required this.name,
      @required this.description,
      @required this.uriImage,
      this.likes,
      this.liked,
      this.id
      //@required this.userOwner
      });
}
