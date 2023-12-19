import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:VisitAveiroFlutter/bloc/local_bloc.dart';
import 'package:VisitAveiroFlutter/bloc/local_event.dart';
import 'package:VisitAveiroFlutter/models/local.dart';
import 'package:VisitAveiroFlutter/services/location_service.dart';
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
            if (_fotoPath != null)
              Image.file(
                File(_fotoPath!),
                width: 300,
                height: 300,
                fit: BoxFit.cover,
            ),
            ElevatedButton(
              onPressed: () => _capturePhoto(),
              child: const Text('Capturar Foto'),
            ),
           _address == null
            ? ElevatedButton(
                onPressed: () => _getCurrentAddress(),
                child: const Text('Usar Localização Atual para Endereço'),
              )
            : Text('Endereço: $_address'),
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
 try {
   EasyLoading.show(status: 'Loading the location...');
   final position = await _locationService.getCurrentLocation();
   final address = await _locationService.getAddressFromLatLng(position.latitude, position.longitude);
   setState(() {
     _currentCoords = LatLng(position.latitude, position.longitude);
     _address = address;
   });
   EasyLoading.dismiss();
   ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(content: Text('Morada obtida com sucesso!')),
   );
 } catch (e) {
   EasyLoading.dismiss();
   print('Erro ao obter localização: $e');
 }
}

void _addLocal() {
  // Verifica se o nome do local foi preenchido
  if (_nomeController.text.isEmpty) {
    _showErrorSnackBar('Por favor, write the name of the location');
    return;
  }

  // Verifica se o endereço foi obtido
  if (_address == null || _address!.isEmpty) {
    _showErrorSnackBar('Por favor, obtenha o endereço.');
    return;
  }

  // Verifica se as coordenadas estão disponíveis
  if (_currentCoords == null) {
    _showErrorSnackBar('Location Error. Please, try again.');
    return;
  }

  if (_fotoPath == null || _fotoPath!.isEmpty){
    _showErrorSnackBar('Please, take the picture.');
    return;
  }

  // Cria o objeto Local e o adiciona
  final Local newLocal = Local(
    name: _nomeController.text,
    type: _selectedType,
    address: _address!,
    fotoPath: _fotoPath, 
    coords: _currentCoords!,
  );

  

  context.read<LocalBloc>().add(AddLocal(newLocal));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Location Added Successfully!')),
  );
  Navigator.pop(context);

}

void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}


}