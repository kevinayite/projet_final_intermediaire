// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/note_model.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;

//   DatabaseHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('notes.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }

//   Future<void> _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE notes (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         title TEXT NOT NULL
//       )
//     ''');
//   }

//   // 1. Créer une note
//   Future<int> insertNote(Note note) async {
//     final db = await instance.database;
//     return await db.insert('notes', note.toMap());
//   }

//   // 2. Récupérer toutes les notes
//   Future<List<Note>> getAllNotes() async {
//     final db = await instance.database;
//     final result = await db.query('notes', orderBy: 'id DESC');
//     return result.map((json) => Note.fromMap(json)).toList();
//   }

//   // 3. Modifier une note
//   Future<int> updateNote(Note note) async {
//     final db = await instance.database;
//     return await db.update(
//       'notes',
//       note.toMap(),
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );
//   }

//   // 4. Supprimer une note
//   Future<int> deleteNote(int id) async {
//     final db = await instance.database;
//     return await db.delete(
//       'notes',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }









import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Table Utilisateurs
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // 2. Table Notes avec liaison user_id
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // --- GESTION UTILISATEURS ---

  // Inscription (Create User)
  Future<int> registerUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  // Verification Connexion (Fetching/Check User)
  Future<User?> loginUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null; // Utilisateur non trouvé ou mot de passe incorrect
  }

  // Vérifier si un nom d'utilisateur existe déjà
  Future<bool> checkUsernameExists(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  // --- GESTION DES NOTES PAR UTILISATEUR ---

  Future<int> insertNote(Note note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  // Récupérer UNIQUEMENT les notes de l'utilisateur connecté
  Future<List<Note>> getNotesByUser(int userId) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}