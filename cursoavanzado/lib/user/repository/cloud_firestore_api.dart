import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../place/model/place.dart';
import '../model/user.dart';

class CloudFirestoreAPI {
  final String USERS = "users";
  final String PLACES = "places";

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserData(UserF user) async {
    CollectionReference users = _db.collection(USERS);
    DocumentReference ref = users.doc(user.uid);

    return await ref.set({
      'uid': user.uid,
      'username': user.username,
      'email': user.email,
      'photoURL': user.photoURL,
      'myPlaces': user.myPlaces,
      'myFavoritePlaces': user.myFavoritePlaces,
      'lastSignIn': DateTime.now()
    }, SetOptions(merge: true));
  }

  Future<void> updatePlaceData(Place place) async {
    CollectionReference refPlaces = _db.collection(PLACES);
    User user = _auth.currentUser;

    await refPlaces.add({
      //'id': place.id,
      'name': place.name,
      'description': place.description,
      //'uriImage':place.uriImage,
      'likes': place.likes,
      'userOwner': "${USERS}/${user.uid}"
    });
  }
}
