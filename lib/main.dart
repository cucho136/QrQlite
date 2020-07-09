import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/despliegue_mapa.dart';
import 'package:qrreaderapp/src/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRreader',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'mapa': (BuildContext context) => DespliegueMapaPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
    );
  }
}
