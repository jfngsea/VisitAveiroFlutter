import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:VisitAveiroFlutter/bloc/location_bloc.dart';
import 'package:VisitAveiroFlutter/services/location_service.dart';
import 'package:VisitAveiroFlutter/views/home_page.dart';
import 'package:VisitAveiroFlutter/models/local.dart';
import 'package:VisitAveiroFlutter/bloc/local_bloc.dart';

// Importe outros arquivos necessários

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive para Flutter
  await Hive.initFlutter();

  // Registra os adaptadores do Hive
  Hive.registerAdapter(LocalAdapter());
  Hive.registerAdapter(LocalTypeAdapter());
  Hive.registerAdapter(LatLngAdapter());


  await Hive.openBox<Local>('Locals');

  // Executa o aplicativo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalBloc>(
          create: (context) => LocalBloc(),
        ),
        BlocProvider<LocationBloc>(
          create: (context) => LocationBloc(locationService: LocationService()),
        ),
      ],
      child: const MaterialApp(
        title: 'Visit-Aveiro',
        home: HomePage(),
      ),
    );
  }
}
