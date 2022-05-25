import 'package:flutter/material.dart';
import 'package:pokedex/components/pages/detail/detail_bloc.dart';
import 'package:pokedex/components/pages/detail/detail_page.dart';
import 'package:pokedex/components/pages/home/home_bloc.dart';
import 'package:pokedex/components/pages/home/home_page.dart';
import 'package:pokedex/components/pages/search_page/search_bloc.dart';
import 'package:pokedex/services/pokemon_service.dart';
import 'package:pokedex/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => PokemonService()),
        ChangeNotifierProvider(
          create: (context) => HomeBloc(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchBloc(
            context.read<PokemonService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailBloc(
            pokemonService: context.read<PokemonService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Pokedex',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: HomePage(),
        routes: {
          '/detail': (context) => const DetailPage(),
        },
      ),
    );
  }
}
