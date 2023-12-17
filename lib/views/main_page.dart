import 'package:flutter/material.dart';
import 'package:project_test/views/add_local_page.dart';
import 'package:project_test/views/gastronomy_page.dart';
import 'package:project_test/views/history_page.dart';
import 'package:project_test/views/leisure_page.dart';
import 'package:project_test/views/map_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testar Localização'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MapPage(coords: null),
                  ),
                );
              },
              child: const Text('Mostrar no Mapa'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LocaisLazerPage()),
                );
              },
              child: const Text('Lazer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LocaisGastronomiaPage()),
                );
              },
              child: const Text('Gastronomia'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LocaisHistoriaPage()),
                );
              },
              child: const Text('História e Cultura'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddLocalPage()),
                );
              },
              child: const Text('Add Local'),
            ),
          ],
        ),
      ),
    );
  }
}
