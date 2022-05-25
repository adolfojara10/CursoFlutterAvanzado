import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:platzi_trips_app/user/repository/cloud_firestore_api.dart';

import '../../place/model/place.dart';
import '../model/user.dart';

class CloudFirestoreRepository {
  final CloudFirestoreAPI _cloudFirestoreAPI = CloudFirestoreAPI();

  void updateUserDataFirestore(UserF user) =>
      _cloudFirestoreAPI.updateUserData(user);

  Future<void> updatePlaceData(Place place) => CloudFirestoreAPI().updatePlaceData(place);
}
