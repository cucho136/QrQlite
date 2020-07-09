import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/block/scans_block.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class DireccionesPage extends StatelessWidget {
  final scanBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scanBloc.obtenerScans();
    return StreamBuilder<List<ScanModel>>(
      stream: scanBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final scan = snapshot.data;

        if (scan.length == 0) {
          return Center(
            child: Text('No hay registro almacenados'),
          );
        }

        return ListView.builder(
          itemCount: scan.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) => scanBloc.borraScans(scan[i].id),
            child: ListTile(
                leading: Icon(
                  Icons.cloud_queue,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(scan[i].valot),
                subtitle: Text('ID: ${scan[i].id}'),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                onTap: () {
                  utils.abrirScan(context, scan[i]);
                }),
          ),
        );
      },
    );
  }
}
