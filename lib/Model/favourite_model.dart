class FavouriteModel {
  final Map<String, dynamic> json;

  FavouriteModel(this.json);

  String get id => json['id'];

  String get url => json['url'];
}
