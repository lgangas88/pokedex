import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/services/pokemon_service.dart';

class DetailBloc extends ChangeNotifier {
  final PokemonService? pokemonService;

  DetailBloc({this.pokemonService});

  Future<Pokemon?> getPokemon(String name) async {
    try {
      return await pokemonService!.getPokemon(query: name);
    } catch (e) {
      return null;
    }
  }
}
