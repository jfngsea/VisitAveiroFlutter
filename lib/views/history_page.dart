import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:VisitAveiroFlutter/models/local.dart';
import 'package:VisitAveiroFlutter/views/map_page.dart';
import 'dart:io';

class LocaisHistoriaPage extends StatelessWidget {
  const LocaisHistoriaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locals = Hive.box<Local>('Locals')
        .values
        .where((local) => local.type == LocalType.HistoriaCultura)
        .toList();

    if (locals.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('History & Culture'),
        ),
        body: const Center(
          child: Text(
            'Não existem pontos de interesse disponíveis.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Scaffold(
    appBar: AppBar(
      title: const Text('History & Culture'),
    ),
    body: ListView.builder(
      itemCount: locals.length,
      itemBuilder: (context, index) {
        final local = locals[index];
        return Card(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showFullImage(context, local.fotoPath),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    local.fotoPath != null 
                      ? SizedBox(
                          height: 200, 
                          width: double.infinity, 
                          child: Image.file(
                            File(local.fotoPath!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : const SizedBox(height: 200, child: Placeholder()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          local.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(local.address),
              ),
              ElevatedButton(
                onPressed: () => _openMapPage(context, local),
                child: const Text('Location'),
              ),
            ],
          ),
        );
      },
    ),
  );
}

  void _showFullImage(BuildContext context, String? imagePath) {
    if (imagePath == null) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Image.file(File(imagePath), fit: BoxFit.contain),
        );
      },
    );
  }
  void _openMapPage(BuildContext context, Local local) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(coords: local.coords),
      ),
    );
  }
}
