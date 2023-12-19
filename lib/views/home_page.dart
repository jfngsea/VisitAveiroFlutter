import 'package:flutter/material.dart';
import 'package:VisitAveiroFlutter/views/main_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/city_of_aveiro.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5), // Overlay escuro semi-transparente
        ),
        child: Column(
          children: [
            const SizedBox(height: 150),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome to Aveiro',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontStyle: FontStyle.italic
                ),
              ),
            ),
            const SizedBox(height: 70),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 40), // Define a largura e altura mínimas do botão
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Pode ajustar o padding se necessário
                    // Outros estilos podem ser adicionados aqui
                  ),
                  child: const Text(
                    'Enter',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}