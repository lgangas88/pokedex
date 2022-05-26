import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database? _database;
  final databaseName = 'gesttiona.db';

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final appDocumentDir = await getApplicationSupportDirectory();
    await appDocumentDir.create(recursive: true);
    final dbPath = join(appDocumentDir.path, databaseName);
    return await databaseFactoryIo.openDatabase(dbPath);
  }
}