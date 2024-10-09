import 'package:flutter/material.dart';
import 'package:poke_app/Firebase/firebase_auth.dart';
import 'package:poke_app/Firebase/firestore_service.dart';
import 'package:poke_app/Model/favourite_model.dart';
import 'package:poke_app/View/Login/login_screen.dart';
import 'package:poke_app/data_manager.dart';
import 'package:provider/provider.dart';
import 'favourites_tab.dart';
import 'home_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();

  late TabController tabController;
  bool isLoading = false;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    _fetchFavouritesData();
    super.initState();
  }

  _fetchFavouritesData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    List<FavouriteModel> favs = await FirestoreService().getUrls();
    DataManager().favourites
      ..clear()
      ..addAll(favs);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<DataManager>();
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.black),
            ),
            onPressed: () async {
              await FirebaseAuthManager.signOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          TabBar(
            controller: tabController,
            dividerColor: Colors.transparent,
            indicatorColor: Colors.grey,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  color: Colors.grey.shade600,
                ),
              ),
              const Tab(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                HomeTab(),
                FavouritesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
