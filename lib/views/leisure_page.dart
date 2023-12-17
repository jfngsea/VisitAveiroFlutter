import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_test/models/local.dart';
import 'package:project_test/views/map_page.dart';
import 'dart:io';

class LocaisLazerPage extends StatelessWidget {
  const LocaisLazerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locals = Hive.box<Local>('Locals')
        .values
        .where((local) => local.type == LocalType.Lazer)
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
        title: const Text('Leisure'),
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
                      Container(
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(
                          local.name,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(local.address),
                ElevatedButton(
                  onPressed: () => _openMapPage(context, local),
                  child: const Text('Localização'),
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
