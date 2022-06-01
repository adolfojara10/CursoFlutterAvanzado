import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platzi_trips_app/user/repository/cloud_firestore_api.dart';

import '../../place/model/place.dart';
import '../../place/ui/widgets/card_image.dart';
import '../model/user.dart';
import '../ui/widgets/profile_place.dart';

class CloudFirestoreRepository {
  final CloudFirestoreAPI _cloudFirestoreAPI = CloudFirestoreAPI();

  void updateUserDataFirestore(UserF user) =>
      _cloudFirestoreAPI.updateUserData(user);

  Future<void> updatePlaceData(Place place) =>
      CloudFirestoreAPI().updatePlaceData(place);

  Stream<QuerySnapshot> placeListStream() =>
      _cloudFirestoreAPI.placeListStream();

  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreAPI.buildMyPlaces(placesListSnapshot);

  List<Place> buildPlaces(
          List<DocumentSnapshot> placesListSnapshot, UserF user) =>
      _cloudFirestoreAPI.buildPlaces(placesListSnapshot, user);

  Future likePlace(Place place, String uid) => _cloudFirestoreAPI.likePlace(place,uid);
  UserF cargarUsuario() => _cloudFirestoreAPI.cargarUsuario();
}
