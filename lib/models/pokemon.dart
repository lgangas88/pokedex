import 'package:pokedex/models/type.dart';

class Pokemon {
  int? id;
  String? name;
  String? url;
  String? get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  int? height;
  int? weight;
  int? order;
  List<Type>? types;

  List<String>? abilities;

  bool isFavorite = false;

  String? getPreviousPokemonImageUrl() {
    final previous = id! - 1;
    return previous != 0
        ? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$previous.png'
        : null;
  }

  String? getNextPokemonImageUrl({bool isLastPokemon = false}) {
    final next = id! + 1;
    return !isLastPokemon
        ? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$next.png'
        : null;
  }

  dynamic mapped;


  Pokemon({
    this.name,
    this.url,
    this.id,
    this.types,
    this.abilities,
    this.height,
    this.weight,
    this.order,
    this.mapped,
  });

  factory Pokemon.fromJson(dynamic data) {
    final String? url = data['url'];

    return Pokemon(
      id: data['id'] ?? int.parse(url!.split('/')[url.split('/').length - 2]),
      name: data['name'],
      url: url,
      types: data['types'] != null
          ? (data['types'] as List)
              .map((e) => Type(name: e['type']['name']))
              .toList()
          : [],
      abilities: data['abilities'] != null
          ? (data['abilities'] as List)
              .map<String>((e) => e['ability']['name'])
              .toList()
          : [],
      weight: data['weight'],
      height: data['height'],
      order: data['order'],
      mapped: data,
    );
  }
}
