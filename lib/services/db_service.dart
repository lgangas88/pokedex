import 'package:pokedex/db/db.dart';
import 'package:sembast/sembast.dart';

class DBService {
  final store = StoreRef.main();

  static const String favoritePokemons = 'favoritePokemons';
  static const String teamName = 'teamName';

  Future setObject(String key, dynamic value) async {
    final db = await DBProvider.db.database;
    await store.record(key).put(db, value);
  }

  Future removeObject(String key) async {
    final db = await DBProvider.db.database;
    await store.record(key).delete(db);
  }

  Future getObject<T>(String key) async {
    final db = await DBProvider.db.database;
    return (await store.record(key).get(db)) as T;
  }

  Future<Stream<RecordSnapshot?>> stream({Filter? filter}) async {
    final db = await DBProvider.db.database;
    return store.stream(db, filter: filter);
  }
}