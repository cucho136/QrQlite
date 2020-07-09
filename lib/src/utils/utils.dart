import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

abrirScan(BuildContext context, ScanModel scan) async {
  if (scan.tipo == 'http') {
    if (await canLaunch(scan.valot)) {
      await launch(scan.valot);
    } else {
      throw 'Could not launch ${scan.valot}';
    }
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}
