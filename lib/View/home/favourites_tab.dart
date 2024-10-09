import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poke_app/Api/api_service.dart';
import 'package:poke_app/data_manager.dart';

import '../../Model/poke.dart';
import '../single_poke/single_poke_screen.dart';

class FavouritesTab extends StatefulWidget {
  const FavouritesTab({super.key});

  @override
  State<FavouritesTab> createState() => _FavouritesTabState();
}

class _FavouritesTabState extends State<FavouritesTab> {
  bool isLoading = false;

  List<Poke?> pokes = [];

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    isLoading = true;
    setState(() {});

    List<Future<Poke?>> pokesFuture = [];

    for (String url in DataManager().favouriteUrls) {
      pokesFuture.add(ApiService().getPoke(url));
    }

    pokes.addAll(await Future.wait(pokesFuture));

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : pokes.isEmpty
            ? const Center(child: Text('No Favourites'))
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2 / 3,
                  ),
                  itemCount: pokes.length,
                  itemBuilder: (context, index) {
                    Poke? poke = pokes[index];
                    if (poke != null) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SinglePokeScreen(
                                    poke: poke,
                                  )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                height: 170,
                                imageUrl: poke.imageUrl,
                              ),
                              const SizedBox(height: 25),
                              Text(
                                poke.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              Text(poke.uiId),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              );
  }
}
