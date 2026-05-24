import 'package:flutter_application_1/models/contact_model.dart';
import 'package:flutter_application_1/models/nota.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE notas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            conteudo TEXT,
            imagem_path TEXT,
            data TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE notas(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              titulo TEXT,
              conteudo TEXT,
              imagem_path TEXT,
              data TEXT
            )
          ''');
        }
      },
    );
  }

  // --- Contatos ---

  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contacts');
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  // --- Notas ---

  Future<int> insertNota(Nota nota) async {
    final db = await database;
    return await db.insert('notas', nota.toMap());
  }

  Future<List<Nota>> getNotas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notas', orderBy: 'id DESC');
    return List.generate(maps.length, (i) => Nota.fromMap(maps[i]));
  }

  Future<int> updateNota(Nota nota) async {
    final db = await database;
    return await db.update(
      'notas',
      nota.toMap(),
      where: 'id = ?',
      whereArgs: [nota.id],
    );
  }

  Future<int> deleteNota(int id) async {
    final db = await database;
    return await db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }
}
