import 'package:flutter/material.dart';
import 'package:pokedex/components/pages/favorite/favorite_page.dart';
import 'package:pokedex/components/pages/home/home_bloc.dart';
import 'package:pokedex/components/pages/search_page/search_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().init();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.watch<HomeBloc>();
    return Scaffold(
      
      body: PageView(
        controller: homeBloc.pageController,
        onPageChanged: homeBloc.changePage,
        children: [
          FavoritePage(),
          SearchPage(),
        ],
      ),
      bottomNavigationBar: _BottonNavigationBar(),
    );
  }
}

class _BottonNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeBloc = context.watch<HomeBloc>();
    return BottomNavigationBar(
      onTap: homeBloc.changePage,
      currentIndex: homeBloc.currentPage,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.catching_pokemon),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '',
        ),
      ],
    );
  }
}
