import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokedex/components/pages/search_page/search_bloc.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchBloc searchBloc;
  @override
  void initState() {
    super.initState();
    searchBloc = context.read<SearchBloc>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final height = MediaQuery.of(context).size.height;
      searchBloc.init(height);
    });
  }

  @override
  void dispose() {
    searchBloc.disposeScrollListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = Provider.of<SearchBloc>(context);
    final pokemonList = searchBloc.pokemonList;
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Expanded(
            child: pokemonList != null
                ? ListView.builder(
                    controller: searchBloc.scrollController,
                    itemBuilder: (_, index) {
                      final item = pokemonList[index];
                      if (index == pokemonList.length - 2 &&
                          pokemonList.length != searchBloc.count) {
                        searchBloc.getPokemonList();
                      }
                      return _PokemonItem(item: item);
                    },
                    itemCount: pokemonList.length,
                  )
                : SpinKitSpinningCircle(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
      floatingActionButton: searchBloc.showFloatingActionButton
          ? FloatingActionButton(
              onPressed: searchBloc.goUp,
              child: const Icon(Icons.keyboard_double_arrow_up_rounded),
            )
          : null,
    );
  }

  AppBar _appBar() => AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          width: 120,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: _SearchPokemonDelegate(),
              );
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      );
}

class _PokemonItem extends StatelessWidget {
  const _PokemonItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Pokemon item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: 'pokemon-${item.name!}',
        child: CircleAvatar(
          backgroundImage: NetworkImage(item.imageUrl!),
          backgroundColor: Colors.transparent,
        ),
      ),
      title: Text(item.name!),
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
    );
  }
}

class _SearchPokemonDelegate extends SearchDelegate {

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
    return FutureBuilder<Pokemon?>(
      future: context.read<SearchBloc>().getPokemon(query),
      builder: (BuildContext context, AsyncSnapshot<Pokemon?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('Pokemon not found :('));
        }

        return ListView(
          children: [
            _PokemonItem(item: snapshot.data!),
          ],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
