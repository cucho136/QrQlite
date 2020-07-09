import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/block/scans_block.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapa_page.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int _currentIndex = 0;

  ///https://www.marca.com/
  ///geo:35.387789290878615,-78.66414442500002

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QAscanner'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                scansBloc.borrarTodos();
              }),
        ],
      ),
      body: _cargarPage(_currentIndex),
      bottomNavigationBar: _crearBottonNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scanQr(context),
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQr(BuildContext context) async {
    ///https://www.marca.com/
    ///geo:35.387789290878615,-78.66414442500002
    //dynamic futureString = '';

    dynamic futureString;

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }
    print(futureString.rawContent);

    if (futureString != null) {
      final scan = ScanModel(valot: futureString.rawContent);
      scansBloc.agregarScan(scan);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.abrirScan(context, scan);
        });
      } else {
        utils.abrirScan(context, scan);
      }
    }
  }

  Widget _crearBottonNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones'),
        ),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget _cargarPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapaPage();
      case 1:
        return DireccionesPage();
      default:
        return MapaPage();
    }
  }
}
