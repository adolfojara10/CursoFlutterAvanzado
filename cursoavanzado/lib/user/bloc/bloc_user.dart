import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/user/repository/auth_repository.dart';
import '../../place/model/place.dart';
import '../model/user.dart';
import '../repository/cloud_firestore_repository.dart';

class UserBloc implements Bloc {
  final _auth_repo = AuthRepository();

  //stream de firebase(si es de otra app como Facebook seria StreamController)
  Stream<User> streamFirebase = FirebaseAuth.instance.authStateChanges();
  Stream<User> get authStatus => streamFirebase;

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

  signOut() {
    _auth_repo.signOut();
  }

  @override
  void dispose() {}
}
