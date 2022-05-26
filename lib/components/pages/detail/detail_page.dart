import 'package:flutter/material.dart';
import 'package:pokedex/components/pages/detail/detail_bloc.dart';
import 'package:pokedex/components/pages/search_page/search_bloc.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
    final detailBloc = context.watch<DetailBloc>();

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Pokemon?>(
            future: detailBloc.getPokemon(pokemon.name!),
            builder: (context, AsyncSnapshot<Pokemon?> snapshot) {
              return Column(
                children: [
                  Flexible(
                    child: LayoutBuilder(builder: (context, constraints) {
                      final circleRadius = constraints.maxHeight;
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          _typeCircle(snapshot.data, circleRadius),
                          _pokemonHero(pokemon, context),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.keyboard_arrow_left_rounded),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          if (snapshot.hasData)
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(snapshot.data!.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border),
                                color: Colors.red,
                                onPressed: () async {
                                  final textToShow = await detailBloc
                                      .saveOrRemovePokemon(snapshot.data!);
                                  print(textToShow);
                                },
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                  Flexible(
                    child: _InfoPokemon(pokemon: snapshot.data),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Padding _pokemonHero(Pokemon pokemon, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'pokemon-${pokemon.name!}',
            child: Image.network(
              pokemon.imageUrl!,
              height: 220,
              width: 220,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            pokemon.name!.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Positioned _typeCircle(Pokemon? pokemon, double circleRadius) {
    return Positioned(
      right: -(circleRadius * 1) / 4,
      top: -(circleRadius * 1) / 4,
      child: Container(
        padding: const EdgeInsets.only(left: 54),
        height: circleRadius,
        width: circleRadius,
        decoration: pokemon != null
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(pokemon.types![0].mainColor!),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                ),
                shape: BoxShape.circle,
              )
            : null,
        child: pokemon != null
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var type in pokemon.types!)
                      Image.asset(type.assetImage!),
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}

class _InfoPokemon extends StatelessWidget {
  _InfoPokemon({
    Key? key,
    this.pokemon,
  }) : super(key: key);

  final Pokemon? pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HEIGHT',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '${pokemon?.height}',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WEIGHT',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '${pokemon?.weight}',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ABILITIES',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '${pokemon?.abilities?.join(', ')}',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORDER',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      '${pokemon?.order}',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Spacer(),
          if (pokemon != null) _PreviousNextPokemon(pokemon: pokemon),
        ],
      ),
    );
  }
}

class _PreviousNextPokemon extends StatelessWidget {
  const _PreviousNextPokemon({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final Pokemon? pokemon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: (pokemon?.id ?? 0) - 1 != 0
              ? TextButton.icon(
                  onPressed: () async {
                    final prevPokemon = await context
                        .read<DetailBloc>()
                        .getPokemon((pokemon!.id! - 1).toString());
                    Navigator.of(context).pushNamed(
                      '/detail',
                      arguments: prevPokemon,
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_left_rounded),
                  label: Image.network(pokemon!.getPreviousPokemonImageUrl()!),
                )
              : const SizedBox(),
        ),
        const Spacer(),
        Container(
          child: (pokemon?.id ?? 0) + 1 != context.read<SearchBloc>().count
              ? TextButton.icon(
                  onPressed: () async {
                    final prevPokemon = await context
                        .read<DetailBloc>()
                        .getPokemon((pokemon!.id! + 1).toString());
                    Navigator.of(context).pushNamed(
                      '/detail',
                      arguments: prevPokemon,
                    );
                  },
                  icon: Image.network(pokemon!.getNextPokemonImageUrl()!),
                  label: const Icon(Icons.keyboard_arrow_right_rounded),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
