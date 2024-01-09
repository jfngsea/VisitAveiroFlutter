import 'package:VisitAveiroFlutter/models/local.dart';
import 'package:VisitAveiroFlutter/views/curator_page.dart';
import 'package:VisitAveiroFlutter/views/list_page_content.dart';
import 'package:flutter/material.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 50, 
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ListPage(
                                    type: LocalType.Lazer,
                                    pagename: 'Leisure'
                                )
                            ),
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
                            MaterialPageRoute(
                                builder: (context) => const ListPage(
                                    type: LocalType.Gastronomia,
                                    pagename: 'Gastronomy'
                                )
                            ),
                          );
                        },
                        child: const Text('Gastronomy'),
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
                            MaterialPageRoute(
                                builder: (context) => const ListPage(
                                    type: LocalType.Historia,
                                    pagename: 'History & Culture'
                                )
                            ),
                          );
                        },
                        child: const Text('History & Culture'),
                      ),
                    ),
                    const SizedBox(height: 100),
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
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CuratorPage()),
                          );
                        },
                        child: const Text('Curator Zone'),
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
