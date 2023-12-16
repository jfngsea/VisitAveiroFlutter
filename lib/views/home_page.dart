import 'package:flutter/material.dart';
import 'package:project_test/views/main_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Homepage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
              child: const Text('Testar Mapa'),
            ),

            // Outros elementos da sua homepage...
          ],
        ),
      ),
    );
  }
}
