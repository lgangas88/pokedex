import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/services/db_service.dart';
import 'package:sembast/sembast.dart';

class FavoriteBloc extends ChangeNotifier {
  final DBService? dbService;

  FavoriteBloc({
    this.dbService,
  });

  late StreamSubscription subscriptionFavoritePokemons;
  String? teamName;
  List<Pokemon> favoritePokemons = [];

  void init() async {
    Stream<RecordSnapshot?> stream = await dbService!.stream();
    subscriptionFavoritePokemons = stream.listen((event) {
      if (event?.key == DBService.favoritePokemons) {
        favoritePokemons =
            (event!.value as List).map((e) => Pokemon.fromJson(e)).toList();
      } else if (event?.key == DBService.teamName) {
        teamName = event!.value;
      }
      notifyListeners();
    });
  }

  void closeSubscription() {
    subscriptionFavoritePokemons.cancel();
  }

  void reorderPosition(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = favoritePokemons.removeAt(oldIndex);
    favoritePokemons.insert(newIndex, item);
    notifyListeners();
    setDBList();
  }

  void setDBList() async {
    final tempList = favoritePokemons.map((e) => e.mapped).toList();
    await dbService!.setObject(DBService.favoritePokemons, tempList);
  }

  void editTeamName(String name) async {
    teamName = name;
    notifyListeners();
    await dbService!.setObject(DBService.teamName, name);
  }
}
