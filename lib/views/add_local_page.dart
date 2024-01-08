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
class AddLocalPage extends StatefulWidget {
  const AddLocalPage({super.key, required this.userid});

  final String userid;

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
        title: const Text('Add Location', style: TextStyle(color: Colors.white)),
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
          const SizedBox(height: 100),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Location Name',
              labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white30,
              filled: true,),
            ),
            const SizedBox(height: 30),
            DropdownButton<LocalType>(
              value: _selectedType,
              onChanged: (LocalType? newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              dropdownColor: Colors.grey[800], // Definindo a cor de fundo do dropdown
              items: LocalType.values.map<DropdownMenuItem<LocalType>>((LocalType value) {
                return DropdownMenuItem<LocalType>(
                  value: value,
                  child: Text(
                    value.toString().split('.').last,
                    style: const TextStyle(color: Colors.white), // Texto branco
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            if (_fotoPath != null)
              Image.file(
                File(_fotoPath!),
                width: 300,
                height: 300,
                fit: BoxFit.cover,
            ),
              const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _capturePhoto(),
              child: const Text('Capture Photo'),
            ),
            const SizedBox(height: 50),
           _address == null
            ? ElevatedButton(
                onPressed: () => _getCurrentAddress(),
                child: const Text('Use Current Location for Address'),
              )
            : Text('$_address', style: const TextStyle(color: Colors.white),),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => _addLocal(),
              child: const Text('Add Local'),
            ),
          ],
        ),
      ),
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
     const SnackBar(content: Text('Address obtained successfully!')),
   );
 } catch (e) {
   EasyLoading.dismiss();
   print('Erro ao obter localização: $e');
 }
}

void _addLocal() {
  // Verifica se o nome do local foi preenchido
  if (_nomeController.text.isEmpty) {
    _showErrorSnackBar('Please, write the name of the location');
    return;
  }

  // Verifica se o endereço foi obtido
  if (_address == null || _address!.isEmpty) {
    _showErrorSnackBar('Please get the address.');
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
    userid: widget.userid,
  );

  

  context.read<LocalBloc>().add(AddLocal(newLocal));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Adding Local...')),
  );
  Navigator.pop(context);

}

void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}


}