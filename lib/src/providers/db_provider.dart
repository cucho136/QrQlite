import 'dart:io';

import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';

export 'package:qrreaderapp/src/models/scan_model.dart';

class DbProvider {
  static Database _database;
  static final DbProvider db = DbProvider._();

  DbProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ('
          'id INTEGER  PRIMARY KEY,'
          'tipo TEXT,'
          'valot TEXT'
          ')');
    });
  }

  // metodos para crear registro

  nuevoScanRaw(ScanModel nuevoScans) async {
    final db = await database;

    final res = await db.rawInsert("INSERT Into Scans(id,tipo,valot) "
        "VALUES ( ${nuevoScans.id}, '${nuevoScans.tipo}', '${nuevoScans.valot}' )");

    return res;
  }

  nuevoScan(ScanModel nuevoScans) async {
    final db = await database;

    final res = await db.insert('Scans', nuevoScans.toJson());

    return res;
  }

  Future<ScanModel> getScanId(int id) async {
    final db = await database;

    final resp = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return resp.isNotEmpty ? ScanModel.fromJson(resp.first) : null;
  }

  Future<List<ScanModel>> getTodoScans() async {
    final db = await database;
    final resp = await db.query('Scans');

    List<ScanModel> list =
        resp.isNotEmpty ? resp.map((c) => ScanModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final resp = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");

    List<ScanModel> list =
        resp.isNotEmpty ? resp.map((c) => ScanModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.update('Scans', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);

    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
}
