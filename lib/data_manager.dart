import 'package:flutter/cupertino.dart';
import 'package:poke_app/Model/favourite_model.dart';

class DataManager extends ChangeNotifier {
  static final DataManager _instance = DataManager._();

  List<FavouriteModel> favourites = [];

  List<String> get favouriteIds => favourites.map((e) => e.id).toList();

  List<String> get favouriteUrls => favourites.map((e) => e.url).toList();

  DataManager._();

  factory DataManager() => _instance;

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  set isLoaded(bool isLoaded) {
    _isLoaded = isLoaded;
    notifyListeners();
  }
}
