import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:VisitAveiroFlutter/views/add_local_page.dart';
import 'package:VisitAveiroFlutter/views/gastronomy_page.dart';
import 'package:VisitAveiroFlutter/views/history_page.dart';
import 'package:VisitAveiroFlutter/views/leisure_page.dart';
import 'package:VisitAveiroFlutter/views/map_page.dart';

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
        title: const Text('Home' , style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/city_of_aveiro.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, // Alinhamento central
                  children: <Widget>[
                    const SizedBox(height: 20),
                    // Cada botão em um Container para controlar a largura
                    SizedBox(
                      width: 200,
                      height: 50, // Largura dos botões
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LocaisLazerPage()),
                          );
                        },
                        child: const Text('Leisure'),
                    ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LocaisGastronomiaPage()),
                          );
                        },
                        child: const Text('Gastronomy'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Botão História e Cultura
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LocaisHistoriaPage()),
                          );
                        },
                        child: const Text('History & Culture'),
                      ),
                    ),
                    const SizedBox(height: 100),
                    // Botão Mostrar no Mapa
                    SizedBox(
                      width: 200,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MapPage(coords: null),
                            ),
                          );
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text('Your location'),
                      ),
                    ),
                    const SizedBox(height: 100),
                    // Botão Add Local
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddLocalPage()),
                          );
                        },
                        child: const Text('Add Local    +'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
