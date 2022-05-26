import 'package:flutter/material.dart';
import 'package:pokedex/components/pages/favorite/favorite_bloc.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().init();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteBloc = context.watch<FavoriteBloc>();
    return Scaffold(
      appBar: _appBar(favoriteBloc),
      body: ReorderableListView(
        header: favoriteBloc.teamName != null
            ? ListTile(
                title: Text(
                  favoriteBloc.teamName!,
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            : const SizedBox(),
        onReorder: favoriteBloc.reorderPosition,
        children: [
          for (var pokemon in favoriteBloc.favoritePokemons)
            _PokemonItem(
              pokemon: pokemon,
              key: ValueKey('favpokemon-${pokemon.id}'),
            ),
        ],
      ),
    );
  }

  AppBar _appBar(FavoriteBloc favoriteBloc) {
    return AppBar(
      title: const Text('Favorites'),
      actions: [
        IconButton(
          onPressed: () async {
            final teamName = await showSearch(
                context: context,
                delegate: _EditTeamNameDelegate(),
                query: favoriteBloc.teamName);
            if (teamName != null && teamName != '') {
              favoriteBloc.editTeamName(teamName);
            }
          },
          icon: const Icon(Icons.edit),
        ),
        Builder(builder: (context) {
          return IconButton(
            onPressed: () async {
              final file = await Navigator.of(context).pushNamed(
                '/camera',
              );

              if (file != null) {
                Navigator.of(context).pushNamed(
                  '/image-preview',
                  arguments: [
                    file,
                    favoriteBloc.favoritePokemons,
                  ],
                );
              }
            },
            icon: const Icon(Icons.camera),
          );
        }),
      ],
    );
  }
}

class _PokemonItem extends StatelessWidget {
  const _PokemonItem({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: 'pokemon-${pokemon.name!}',
        child: CircleAvatar(
          backgroundImage: NetworkImage(pokemon.imageUrl!),
          backgroundColor: Colors.transparent,
        ),
      ),
      title: Text(pokemon.name!),
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: pokemon),
    );
  }
}

class _EditTeamNameDelegate extends SearchDelegate {
  _EditTeamNameDelegate()
      : super(
          searchFieldLabel: 'Team name',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        );
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear),
        ),
      IconButton(
        onPressed: () {
          if (query.isNotEmpty) close(context, query);
        },
        icon: const Icon(Icons.check),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.keyboard_arrow_left_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
