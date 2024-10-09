import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poke_app/Model/poke.dart';
import 'package:poke_app/Model/poke_list.dart';

class ApiService {
  Future<PokeList?> getPokeList(String url) async {
    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);

        PokeList pokeList = PokeList(json);

        return pokeList;
      } else {
        return null;
      }
    } catch (e) {
      print('Errorr $e');
      return null;
    }
  }

  Future<Poke?> getPoke(String url) async {
    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        Poke poke = Poke(jsonDecode(res.body));

        return poke;
      } else {
        return null;
      }
    } catch (e) {
      print('Error poke $e');

      return null;
    }
  }
}
