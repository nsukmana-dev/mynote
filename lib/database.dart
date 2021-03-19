import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Note.dart';

class DBHelper {
  Database _database;

  Future<Database> get dbInstance async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'notesapp.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, body TEXT)",
        );
      },
    );
  }

  Future<List<Note>> getNotes() async {
    final db = await dbInstance;

    // final List<Map<String, dynamic>> maps = await db.query('notes', orderBy: 'id DESC');
    final List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
      );
    });
  }

  Future<void> saveNote(Note note) async {
    final db = await dbInstance;
    await db.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateNote(Note note) async {
    final db = await dbInstance;
    await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(noteId) async {
    final db = await dbInstance;
    await db.delete('notes', where: 'id = ?', whereArgs: [noteId]);
  }
}
