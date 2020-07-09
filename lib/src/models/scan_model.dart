import 'package:latlong/latlong.dart';

class ScanModel {
  ScanModel({
    this.id,
    this.tipo,
    this.valot,
  }) {
    if (this.valot.contains('http')) {
      this.tipo = 'http';
    } else {
      this.tipo = 'geo';
    }
  }

  int id;
  String tipo;
  String valot;

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valot: json["valot"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valot": valot,
      };

  LatLng getLatLng() {
    final lalo = valot.substring(4).split(',');
    final latitud = double.parse(lalo[0]);
    final lng = double.parse(lalo[1]);

    return LatLng(latitud, lng);
  }
}
