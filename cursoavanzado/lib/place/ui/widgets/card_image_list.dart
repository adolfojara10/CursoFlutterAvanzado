import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import '../../../user/bloc/bloc_user.dart';
import '../../../user/model/user.dart';
import '../../model/place.dart';
import 'card_image.dart';

class CardImageList extends StatefulWidget {
  UserF user;

  CardImageList(@required this.user);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CardImageList();
  }
}

class _CardImageList extends State<CardImageList> {
  UserBloc userBloc;

  get iconDataLike => null;

  Widget listViewPlaces(List<Place> places) {
    return ListView(
      padding: EdgeInsets.all(25.0),
      scrollDirection: Axis.horizontal,
      children: places.map((place) {
        return CardImageWithFabICON(
          pathImage: place.uriImage,
          width: 300.0,
          height: 250.0,
          left: 20.0,
          iconData: place.liked ? iconDataLike : iconDataLike,
          onPressedFabIcon: () {
            setLiked(place);
          },
          internet: true,
        );
      }).toList(),
    );
  }

  void setLiked(Place place) {
    setState(() {
      place.liked = !place.liked;
      userBloc.likePlace(place, widget.user.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    // TODO: implement build
    return Container(
        height: 350.0,
        child: StreamBuilder(
            // ignore: missing_return
            builder: (context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.none:
                  return CircularProgressIndicator();
                case ConnectionState.active:
                  print("PLACESLIST: ACTIVE");
                  return listViewPlaces(userBloc.buildPlaces(
                      snapshot.data.docs, widget.user));
                case ConnectionState.done:
                  print("PLACESLIST: DONE");
                  return listViewPlaces(userBloc.buildPlaces(
                      snapshot.data.documents, widget.user));
                default:
              }
            },
            stream: userBloc.placeListStream()));
  }
}
