import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poke_app/Model/favourite_model.dart';
import 'package:poke_app/data_manager.dart';
import '../../Api/api_service.dart';
import '../../Firebase/firestore_service.dart';
import '../../Model/poke.dart';
import '../../Model/poke_list.dart';
import '../single_poke/single_poke_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool isLoading = false;
  List<MapEntry<String, String>> pokesUrls = [];
  PokeList? pokeList;
  List<Poke?> pokes = [];
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        if (searchController.text.trim().isNotEmpty) return;
        if (scrollController.offset == scrollController.position.maxScrollExtent) {
          if (pokeList != null && pokeList!.next == null) return;
          _fetchData();
        }
      });
    });

    super.initState();
  }

  _fetchData() async {
    isLoading = true;
    setState(() {});
    pokeList = await ApiService().getPokeList(pokeList?.next ?? 'https://pokeapi.co/api/v2/pokemon?offset=0&limit=20');

    if (pokeList != null) {
      List<String> urls = pokeList!.pokesUrls;
      pokesUrls.addAll(pokeList!.pokesMetadata);

      List<Future<Poke?>> pokesFuture = [];

      for (String url in urls) {
        pokesFuture.add(ApiService().getPoke(url));
      }

      pokes.addAll(await Future.wait(pokesFuture));
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Poke?> filteredPokes = searchController.text.trim().isEmpty
        ? pokes
        : pokes.where((e) => e?.name.contains(searchController.text.trim()) ?? false).toList();
    return isLoading && filteredPokes.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : filteredPokes.isEmpty && searchController.text.trim().isEmpty
            ? const Text('No Data')
            : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    child: Text(
                      'Search for a Pokemon by name or using its National pokedex number',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: _manageSearch,
                              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Name or Number'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: GridView.builder(
                            controller: scrollController,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 2 / 3,
                            ),
                            itemCount: filteredPokes.length,
                            itemBuilder: (context, index) {
                              Poke poke = filteredPokes[index]!;
                              String url = pokesUrls.firstWhere((e) => e.key == poke.name).value;
                              return _PokeTile(
                                poke: poke,
                                url: url,
                              );
                            },
                          ),
                        ),
                        if (isLoading && filteredPokes.isNotEmpty)
                          Container(
                            color: Colors.black.withOpacity(0.2),
                            height: 60.0,
                            padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
  }

  _manageSearch(String? data) {
    setState(() {});
  }
}

class _PokeTile extends StatefulWidget {
  const _PokeTile({required this.poke, required this.url});

  final Poke poke;
  final String url;

  @override
  State<_PokeTile> createState() => _PokeTileState();
}

class _PokeTileState extends State<_PokeTile> {
  bool get isFavourite => DataManager().favouriteIds.contains(widget.poke.id.toString());

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: _onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                CachedNetworkImage(
                  height: 170,
                  imageUrl: widget.poke.imageUrl,
                ),
                const SizedBox(height: 25),
                Text(
                  widget.poke.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(widget.poke.uiId),
              ],
            ),
          ),
        ),
        Positioned(
          right: 15,
          top: 15,
          child: InkWell(
            onTap: _manageFavourite,
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: isLoading
                  ? const SizedBox.square(
                      dimension: 15.0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: isFavourite ? Colors.red : Colors.grey,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  _manageFavourite() async {
    setState(() {
      isLoading = true;
    });
    if (isFavourite) {
      // remove
      await FirestoreService().removeFromFavourite(widget.poke.id);
    } else {
      // add
      await FirestoreService().addToFavourite(FavouriteModel({
        'id': widget.poke.id.toString(),
        'url': widget.url,
      }));
    }
    setState(() {
      isLoading = false;
    });
  }

  _onTap() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SinglePokeScreen(
              poke: widget.poke,
            )));
  }
}
