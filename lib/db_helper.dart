import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as pth;

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = pth.join(databasesPath, 'user.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user (
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT,
        phone TEXT,
        email TEXT,
        address TEXT
      )
    ''');
  }

  Future<int> saveUser(User user) async {
    var dbClient = await database;
    return dbClient.insert('user', user.toMap());
  }

  Future<List<User>> getAllUsers(String dd) async {
    var dbClient = await database;
    List<Map<String, dynamic>> userList = await dbClient.query('user');
    return userList.map((json) => User.fromJson(json)).toList();
  }






}

class User {
  int? id;
  String username;
  String password;
  String phone;
  String email;
  String address;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      username: json['username'] ,
      password: json['password'] ,
      phone: json['phone'] ,
      email: json['email'] ,
      address: json['address'] ,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}
