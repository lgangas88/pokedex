import 'package:pokedex/models/pokemon.dart';

class GetPokemonListResponse {
  final int? count;
  final String? next;
  final String? previous;
  final List<Pokemon>? results;

  GetPokemonListResponse({this.count, this.next, this.previous, this.results});

  factory GetPokemonListResponse.fromJson(dynamic data) {
    return GetPokemonListResponse(
      count: data['count'],
      next: data['next'],
      previous: data['previous'],
      results: data['results'] != null
          ? (data['results'] as List).map((e) => Pokemon.fromJson(e)).toList()
          : [],
    );
  }
}