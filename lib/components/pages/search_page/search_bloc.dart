import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/services/pokemon_service.dart';

class SearchBloc extends ChangeNotifier {
  final PokemonService pokemonService;

  SearchBloc(this.pokemonService);

  late ScrollController scrollController;
  bool showFloatingActionButton = false;
  late double sizeHeight;

  List<Pokemon>? pokemonList;
  String? next;
  String? previous;
  int? count;

  void init(double height) {
    sizeHeight = height;
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    getPokemonList();
  }

  void goUp() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
    );
  }

  void scrollListener() {
    showFloatingActionButton = scrollController.offset > sizeHeight;
    notifyListeners();
  }

  void disposeScrollListener() {
    scrollController.removeListener(scrollListener);
  }

  void getPokemonList() async {
    try {
      final response = await pokemonService.getPokemonList(url: next);
      pokemonList = [
        ...pokemonList ?? [],
        ...response.results ?? [],
      ];
      next = response.next;
      previous = response.previous;
      count = response.count;
      notifyListeners();
    } catch (e) {
      print('Error $e');
    }
  }

  Future<Pokemon?> getPokemon(String query) async {
    try {
      return await pokemonService.getPokemon(query: query.toLowerCase());
    } catch (e) {
      return null;
    }
  }
}
