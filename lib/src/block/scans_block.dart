import 'dart:async';

import 'package:qrreaderapp/src/block/validator.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp =>
      _scansController.stream.transform(validarHttp);

  dispose() {
    _scansController?.close();
  }

  agregarScan(ScanModel scan) async {
    await DbProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  obtenerScans() async {
    _scansController.sink.add(await DbProvider.db.getTodoScans());
  }

  borraScans(int id) async {
    await DbProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarTodos() async {
    await DbProvider.db.deleteAll();
    _scansController.sink.add([]);
  }
}
