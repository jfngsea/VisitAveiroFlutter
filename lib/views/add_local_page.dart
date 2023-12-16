import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_test/bloc/local_bloc.dart';
import 'package:project_test/bloc/local_event.dart';
import 'package:project_test/models/local.dart';
import 'package:project_test/services/location_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddLocalPage extends StatefulWidget {
  const AddLocalPage({super.key});

  @override
  _AddLocalPageState createState() => _AddLocalPageState();
}

class _AddLocalPageState extends State<AddLocalPage> {
  final TextEditingController _nomeController = TextEditingController();
  LocalType _selectedType = LocalType.Lazer; // Valor padrão
  String? _fotoPath;
  String? _address;
  LatLng? _currentCoords;

  final ImagePicker _picker = ImagePicker();
  final LocationService _locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Local'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Local'),
            ),
            DropdownButton<LocalType>(
              value: _selectedType,
              onChanged: (LocalType? newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              items: LocalType.values.map<DropdownMenuItem<LocalType>>((LocalType value) {
                return DropdownMenuItem<LocalType>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () => _capturePhoto(),
              child: const Text('Capturar Foto'),
            ),
            ElevatedButton(
              onPressed: () => _getCurrentAddress(),
              child: const Text('Usar Localização Atual para Endereço'),
            ),
            ElevatedButton(
              onPressed: () => _addLocal(),
              child: const Text('Adicionar Local'),
            ),
          ],
        ),
      ),
    );
  }

  void _capturePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _fotoPath = photo.path;
      });
    }
  }

  void _getCurrentAddress() async {
    final position = await _locationService.getCurrentLocation();
    setState(() async {
      _currentCoords = LatLng(position.latitude, position.longitude);
      _address = await _locationService.getAddressFromLatLng(position.latitude, position.longitude);
    });
  }

  void _addLocal() {
    if (_currentCoords == null) {
      // Lidar com o caso de coordenadas não estarem disponíveis
      return;
    }

    final Local newLocal = Local(
      name: _nomeController.text,
      type: _selectedType,
      address: _address ?? 'Endereço não disponível',
      fotoPath: _fotoPath, 
      coords: _currentCoords!,
    );

    context.read<LocalBloc>().add(AddLocal(newLocal));
    Navigator.pop(context);

    _printLocalData(); 
  }

  void _printLocalData() {
    final box = Hive.box<Local>('Locals');
    print('Dados atuais na Box:');
    for (var local in box.values) {
      print('Nome: ${local.name}, Tipo: ${local.type}, Endereço: ${local.address}, Foto: ${local.fotoPath}');
    }
  }
}
