import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/user/repository/auth_repository.dart';
import 'package:platzi_trips_app/user/repository/cloud_firestore_api.dart';
import '../../place/model/place.dart';
import '../../place/ui/widgets/card_image.dart';
import '../model/user.dart';
import '../repository/cloud_firestore_repository.dart';
import 'package:platzi_trips_app/place/repository/firebase_storage_repo.dart';

import '../ui/widgets/profile_place.dart';

class UserBloc implements Bloc {
  final _auth_repo = AuthRepository();

  //stream de firebase(si es de otra app como Facebook seria StreamController)
  Stream<User> streamFirebase = FirebaseAuth.instance.authStateChanges();
  Stream<User> get authStatus => streamFirebase;

  Future<User> currentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  //casos de uso de user
  //Sign in
  Future<UserCredential> signIn() {
    return _auth_repo.signInFirebase();
  }

  //registrar usuario en bbdd

  final _cloudFirestoreRepository = CloudFirestoreRepository();

  void updateUserData(UserF user) =>
      _cloudFirestoreRepository.updateUserDataFirestore(user);

  Future<void> updatePlaceDate(Place place) =>
      _cloudFirestoreRepository.updatePlaceData(place);

  Stream placeListStream() => _cloudFirestoreRepository.placeListStream();

  final FirebaseStorageRepository _firebaseStorageRepository =
      FirebaseStorageRepository();

  Future<UploadTask> uploadFile(String path, File image) =>
      _firebaseStorageRepository.uploadFile(path, image);

  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreRepository.buildMyPlaces(placesListSnapshot);

  Stream<QuerySnapshot> myPlacesListSream(String uid) =>
      FirebaseFirestore.instance
          .collection(CloudFirestoreAPI().PLACES)
          .where("userOwner",
              isEqualTo: FirebaseFirestore.instance
                  .doc("${CloudFirestoreAPI().USERS}/${uid}"))
          .snapshots();

  List<Place> buildPlaces(
          List<DocumentSnapshot> placesListSnapshot, UserF user) =>
      _cloudFirestoreRepository.buildPlaces(placesListSnapshot, user);

  Future likePlace(Place place, String uid) => _cloudFirestoreRepository.likePlace(place,uid);

  signOut() {
    _auth_repo.signOut();
  }

  @override
  void dispose() {}
}
