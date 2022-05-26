import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:pokedex/components/pages/image_preview/image_preview_bloc.dart';
import 'package:pokedex/components/widgets/widget_to_image.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:provider/provider.dart';

class ImagePreviewPage extends StatefulWidget {
  const ImagePreviewPage({Key? key}) : super(key: key);

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  late GlobalKey bodyKey;

  @override
  Widget build(BuildContext context) {
    final imagePreviewBloc = context.watch<ImagePreviewBloc>();
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    final imageFile = arguments[0] as File;

    return Scaffold(
      appBar: _appBar(),
      body: WidgetToImage(
        builder: (key) {
          bodyKey = key;
          return Stack(
            fit: StackFit.expand,
            children: [
              SizedBox(
                  width: double.infinity,
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                  )),
              for (var index
                  in imagePreviewBloc.pokemonOnScreen.asMap().entries.toList())
                _PokemonSticker(pokemon: index.value!, index: index.key),
            ],
          );
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: const BackButton(),
      actions: [
        IconButton(
          onPressed: _onShowGridView,
          icon: const Icon(Icons.auto_fix_high),
        ),
        IconButton(
          onPressed: () async {
            final bytes = await WidgetToImage.capture(bodyKey);
            String message =
                await context.read<ImagePreviewBloc>().downloadImage(bytes!);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
          icon: const Icon(Icons.save),
        ),
      ],
    );
  }

  void _onShowGridView() async {
    final Pokemon? selectedPokemon = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.0),
        ),
      ),
      builder: (_) {
        final pokemonList = (ModalRoute.of(context)!.settings.arguments
            as List)[1] as List<Pokemon>;
        final imagePreviewBloc = context.read<ImagePreviewBloc>();
        List<Pokemon> tempPokemonList = [];
        for (var pokemon in pokemonList) {
          Pokemon? pk = imagePreviewBloc.pokemonOnScreen.firstWhere(
            (f) => f?.id == pokemon.id,
            orElse: () => null,
          );
          if (pk == null) {
            tempPokemonList.add(pokemon);
          }
        }
        return _GridList(tempPokemonList);
      },
    );

    if (selectedPokemon != null) {
      context.read<ImagePreviewBloc>().addPokemonOnScreen(selectedPokemon);
    }
  }
}

class _GridList extends StatelessWidget {
  const _GridList(
    this.pokemonList, {
    Key? key,
  }) : super(key: key);

  final List<Pokemon> pokemonList;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: [
        for (var pokemon in pokemonList)
          GestureDetector(
            onTap: () => Navigator.of(context).pop(pokemon),
            child: Image.network(pokemon.imageUrl!),
          ),
      ],
    );
  }
}

class _PokemonSticker extends StatefulWidget {
  const _PokemonSticker({
    Key? key,
    required this.pokemon,
    required this.index,
  }) : super(key: key);

  final Pokemon pokemon;
  final int index;

  @override
  State<_PokemonSticker> createState() => _PokemonStickerState();
}

class _PokemonStickerState extends State<_PokemonSticker> {
  late Offset position;

  @override
  void initState() {
    super.initState();
    position = const Offset(0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onLongPress: () {
          context.read<ImagePreviewBloc>().removePokemonOnScreen(widget.index);
        },
        child: Draggable(
          feedback: _pokemonImage(),
          childWhenDragging: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.color,
            ),
            child: _pokemonImage(),
          ),
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            setState(() => position = offset);
          },
          child: _pokemonImage(),
        ),
      ),
    );
  }

  Image _pokemonImage() {
    return Image.network(
      widget.pokemon.imageUrl!,
      height: 80,
      width: 80,
    );
  }
}
