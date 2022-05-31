import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../place/model/place.dart';
import '../model/user.dart';
import '../ui/widgets/profile_place.dart';

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
      'uriImage': place.uriImage,
      'likes': place.likes,
      'userOwner': _db.doc("${USERS}/${user.uid}")
    }).then((DocumentReference dr) {
      dr.get().then((DocumentSnapshot ds) {
        ds.id;

        DocumentReference refUsers = _db.collection(USERS).doc(user.uid);
        refUsers.update({
          "myPlaces": FieldValue.arrayUnion([_db.doc("$PLACES/${ds.id}")])
        });
      });
    });
  }

  Stream<QuerySnapshot> placeListStream() {
    User user = _auth.currentUser; //Para saber el uid del usuario actual

    return _db
        .collection(PLACES)
        .where('userOwner', isEqualTo: _db.collection(USERS).doc(user?.uid))
        .snapshots();
  }

  List<ProfilePlace> buildPlaces(List<DocumentSnapshot> placesListSnapshot) {
    // ignore: deprecated_member_use
    List<ProfilePlace> profilePlaces = List<ProfilePlace>();
    placesListSnapshot.forEach((p) {
      profilePlaces.add(ProfilePlace(Place(
          name: p['name'],
          description: p['description'],
          uriImage: p['uriImage'],
          likes: p['likes'])));
    });

    return profilePlaces;
  }
}
