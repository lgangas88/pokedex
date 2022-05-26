import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokedex/models/pokemon.dart';

class ImagePreviewBloc extends ChangeNotifier {
  List<Pokemon?> pokemonOnScreen = [];

  void addPokemonOnScreen(Pokemon pokemon) {
    pokemonOnScreen.add(pokemon);
    notifyListeners();
  }

  void removePokemonOnScreen(int index) {
    pokemonOnScreen.removeAt(index);
    notifyListeners();
  }

  Future<String> downloadImage(Uint8List bytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final date = DateTime.now();
      File file = await File('${tempDir.path}/$date-pokedex.png').create();
      file.writeAsBytesSync(bytes);
      await GallerySaver.saveImage(file.path);
      return 'Saved image, share with your friends :3';
    } catch (e) {
      print(e);
      return 'Something went wrong :/';
    }
  }
}
