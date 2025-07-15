import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PortfolioCoin {
  final int? id;
  final String name;
  final String symbol;
  final double value;
  final double change;
  final String iconPath;

  PortfolioCoin({this.id, required this.name, required this.symbol, required this.value, required this.change, required this.iconPath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'value': value,
      'change': change,
      'iconPath': iconPath,
    };
  }

  factory PortfolioCoin.fromMap(Map<String, dynamic> map) {
    return PortfolioCoin(
      id: map['id'] as int?,
      name: map['name'] as String,
      symbol: map['symbol'] as String,
      value: map['value'] as double,
      change: map['change'] as double,
      iconPath: map['iconPath'] as String,
    );
  }
}

class CoinDatabase {
  static final CoinDatabase instance = CoinDatabase._init();
  static Database? _database;

  CoinDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('coins.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE coins (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        symbol TEXT,
        value REAL,
        change REAL,
        iconPath TEXT
      )
    ''');
  }

  Future<List<PortfolioCoin>> getCoins() async {
    final db = await instance.database;
    final result = await db.query('coins');
    return result.map((json) => PortfolioCoin.fromMap(json)).toList();
  }

  Future<int> addCoin(PortfolioCoin coin) async {
    final db = await instance.database;
    return await db.insert('coins', coin.toMap());
  }

  Future<int> removeCoin(int id) async {
    final db = await instance.database;
    return await db.delete('coins', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
} 