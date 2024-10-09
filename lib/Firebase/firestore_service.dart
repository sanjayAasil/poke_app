import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poke_app/Model/favourite_model.dart';
import 'package:poke_app/data_manager.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFavourite(FavouriteModel favouriteModel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference favourites = _firestore.collection('users').doc(userId).collection('favourites');

    await favourites.doc(favouriteModel.id).set(favouriteModel.json);
    DataManager().favourites.add(favouriteModel);
  }

  Future<void> removeFromFavourite(int id) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> favourites =
        _firestore.collection('users').doc(userId).collection('favourites');

    await favourites.doc(id.toString()).delete();
    DataManager().favourites.removeWhere((e) => e.id == id.toString());
  }

  Future<List<FavouriteModel>> getUrls() async {
    List<FavouriteModel> urls = [];
    String userId = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> favourites =
        _firestore.collection('users').doc(userId).collection('favourites');

    var snapshot = await favourites.get();

    for (var doc in snapshot.docs) {
      urls.add(FavouriteModel(doc.data()));
    }

    return urls;
  }
}
