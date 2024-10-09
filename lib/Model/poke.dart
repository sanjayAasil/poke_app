class Poke {
  final Map<String, dynamic> json;

  Poke(this.json);

  int get id => json['id'];

  String get uiId => id.toString().padLeft(2, '00');

  String get name => json['name'];

  String get imageUrl => json['sprites']['other']['home']['front_default'];

  String get frontShiny => json['sprites']['other']['home']['front_shiny'];

  String get artImage => json['sprites']['other']['official-artwork']['front_default'];

  String get backDefaultImage => json['sprites']['other']['official-artwork']['front_shiny'];
}
