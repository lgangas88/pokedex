import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/services/db_service.dart';
import 'package:pokedex/services/pokemon_service.dart';

class DetailBloc extends ChangeNotifier {
  final PokemonService? pokemonService;
  final DBService? dbService;

  DetailBloc({this.pokemonService, this.dbService});

  Future<Pokemon?> getPokemon(String name) async {
    try {
      final pokemon = await pokemonService!.getPokemon(query: name);
      final favoritePokemons =
          (await dbService!.getObject(DBService.favoritePokemons) ?? [])
              as List;
      final favoritePokemon = favoritePokemons
          .firstWhere((e) => e['id'] == pokemon.id, orElse: () => null);
      pokemon.isFavorite = favoritePokemon != null;
      return pokemon;
    } catch (e) {
      return null;
    }
  }

  Future<String> saveOrRemovePokemon(Pokemon pokemon) async {
    try {
      final favoritePokemons =
          (await dbService!.getObject(DBService.favoritePokemons) ?? [])
              as List;
      final tempFavoritePokemon = favoritePokemons.toList();
      String textToShow = '';
      if (pokemon.isFavorite) {
        tempFavoritePokemon.removeWhere((e) => e['id'] == pokemon.id);
        textToShow = 'You released this Pokemon!';
      } else {
        tempFavoritePokemon.add(pokemon.mapped);
        textToShow = 'You catched this Pokemon! *_*';
      }
      await dbService!.setObject(DBService.favoritePokemons, tempFavoritePokemon);
      notifyListeners();
      return textToShow;
    } catch (e) {
      print(e);
      return 'Error when trying save pokemon';
    }
  }
}
