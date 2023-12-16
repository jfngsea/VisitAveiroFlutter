import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_test/bloc/local_event.dart';
import 'package:project_test/bloc/local_state.dart';
import 'package:project_test/models/local.dart';
import 'package:hive_flutter/hive_flutter.dart';


class LocalBloc extends Bloc<LocalEvent, LocalState> {
  final Box<Local> localBox;


  LocalBloc() : localBox = Hive.box<Local>('Locals'), super(LocalInitial()) {
    on<AddLocal>(_onAddLocal);
  }


  Future<void> _onAddLocal(AddLocal event, Emitter<LocalState> emit) async {
    await localBox.add(event.local);
    emit(LocalsLoaded(localBox.values.toList()));
  }
}
