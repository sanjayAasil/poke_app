import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poke_app/Model/poke.dart';
import 'package:poke_app/View/single_poke/poke_tab.dart';

class SinglePokeScreen extends StatelessWidget {
  final Poke poke;

  const SinglePokeScreen({super.key, required this.poke});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              poke.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Text(
              poke.uiId,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: poke.imageUrl,
                  ),
                ),
              ),
            )
          ];
        },
        body: PokeTab(poke: poke),
      ),
    );
  }
}
