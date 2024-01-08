import 'package:VisitAveiroFlutter/bloc/local_event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:VisitAveiroFlutter/bloc/location_bloc.dart';
import 'package:VisitAveiroFlutter/services/location_service.dart';
import 'package:VisitAveiroFlutter/views/home_page.dart';
import 'package:VisitAveiroFlutter/models/local.dart';
import 'package:VisitAveiroFlutter/bloc/local_bloc.dart';
import 'package:VisitAveiroFlutter/providers/auth_provider.dart';

import 'package:provider/provider.dart';

import 'firebase_options.dart';

// Importe outros arquivos necessários
Future<void> addLocalToHiveBox() async {
  
  
  try {
    var box = Hive.box<Local>('Locals');
    if (box.isEmpty) {
      print("Adicionando local de teste à caixa Hive...");
      var localTest = Local(
        name: "Ria de Aveiro",
        type: LocalType.Lazer,
        address: "Rua Glória e Vera Cruz",
        fotoPath: "lib/assets/images/test.jpg",
        coords: const LatLng(40.6412, -8.6536),
      );

      var localTest2 = Local(
        name: "Universidade de Aveiro",
        type: LocalType.Historia,
        address: "Campus Universitário de Santiago",
        fotoPath: "lib/assets/images/test.jpg",
        coords: const LatLng(40.629728, -8.657860),
      );
      await box.add(localTest);
      await box.add(localTest2);
      print("Local de teste adicionado.");
    } else {
      print("Caixa Hive já contém dados.");
    }
  } catch (e) {
    print("Erro ao adicionar local à caixa Hive: $e");
  }
}

Future<void> clearHiveBox() async {
  var box = Hive.box<Local>('Locals');
  await box.clear();
}

Future<void> printLocalData() async {
    final box = Hive.box<Local>('Locals');
    print('Dados atuais na Box:');
    for (var local in box.values) {
      print('Nome: ${local.name}, Tipo: ${local.type}, Endereço: ${local.address}, Foto: ${local.fotoPath}');
    }
  }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(LocalAdapter());
  Hive.registerAdapter(LocalTypeAdapter());
  Hive.registerAdapter(LatLngAdapter());


  await Hive.openBox<Local>('Locals');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  runApp(const MyApp());
  //clearHiveBox();
  WidgetsBinding.instance.addPostFrameCallback((_) async{
    await addLocalToHiveBox();
   await printLocalData();
  });
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalBloc>(
          create: (context) => LocalBloc()..add(GetAllLocals()),
        ),
        BlocProvider<LocationBloc>(
          create: (context) => LocationBloc(locationService: LocationService()),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
        ],
        child:MaterialApp(
          title: 'Visit-Aveiro',
          home: const HomePage(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}