import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

class DespliegueMapaPage extends StatefulWidget {
  @override
  _DespliegueMapaPageState createState() => _DespliegueMapaPageState();
}

class _DespliegueMapaPageState extends State<DespliegueMapaPage> {
  String tipoMapa = 'streets-v11';

  final map = new MapController();

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        //streets, dark, light, outdoors, satellite

        if (tipoMapa == 'streets-v11') {
          tipoMapa = 'dark-v10';
        } else if (tipoMapa == 'dark-v10') {
          tipoMapa = 'light-v10';
        } else if (tipoMapa == 'light-v10') {
          tipoMapa = 'outdoors-v11';
        } else if (tipoMapa == 'outdoors-v11') {
          tipoMapa = 'satellite-v9';
        } else if (tipoMapa == 'satellite-v9') {
          tipoMapa = 'satellite-streets-v11';
        } else {
          tipoMapa = 'streets-v11';
        }

        setState(() {});
      },
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  LayerOptions _crearMapa() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/styles/v1/'
            'mapbox/$tipoMapa/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiY3VjaG8xMzYiLCJhIjoiY2tjZjU5ZDVjMDljczMybzNid2dkbjl6byJ9.gRDN6KaNOwjjo5bfhfzO8g',
          'id': 'mapbox.$tipoMapa'
          //streets, dark, light, outdoors, satellite
        });
  }

  LayerOptions _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 45.0,
                  color: Theme.of(context).primaryColor,
                ),
              ))
    ]);
  }
}
