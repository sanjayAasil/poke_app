class PokeList {
  final Map<String, dynamic> json;

  PokeList(this.json);

  int get count => json['count'];

  String? get next => json['next'];

  String? get previous => json['previous'];

  List<String> get pokesUrls => List.of(json['results']).map((e) => e['url'] as String).toList();

  List<MapEntry<String, String>> get pokesMetadata =>
      List.from(json['results']).map((e) => MapEntry(e['name'] as String, e['url'] as String)).toList();
}
