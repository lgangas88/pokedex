import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedex/environment.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/responses/pokemon_responses.dart';

class PokemonService {
  Future<GetPokemonListResponse> getPokemonList({String? url}) async {
    final uri = Uri.parse(url ?? '${environment['baseUrl']}${ApiV2.pokemon}');
    final response = await http.get(uri);
    return GetPokemonListResponse.fromJson(jsonDecode(response.body));
  }

  Future<Pokemon> getPokemon({String? url, String? query}) async {
    final uri = Uri.parse(url ?? '${environment['baseUrl']}${ApiV2.pokemon}$query');
    final response = await http.get(uri);
    return Pokemon.fromJson(jsonDecode(response.body));
  }
}
