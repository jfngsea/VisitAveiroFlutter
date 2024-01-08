import 'dart:io';

import 'package:VisitAveiroFlutter/utils/check_internet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:VisitAveiroFlutter/bloc/local_event.dart';
import 'package:VisitAveiroFlutter/bloc/local_state.dart';
import 'package:VisitAveiroFlutter/models/local.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class LocalBloc extends Bloc<LocalEvent, LocalState> {
  final Box<Local> localBox;


  LocalBloc() : localBox = Hive.box<Local>('Locals'), super(LocalInitial()) {
    on<AddLocal>(_onAddLocal);
    on<DeleteLocal>(_onDeleteLocal);
    on<GetAllLocals>(_onGetAllLocals);
    add(GetAllLocals());
  }

  Future<void> _onAddLocal(AddLocal event, Emitter<LocalState> emit) async {
    bool isOnline = await checkNetwork();
    if(!(isOnline)){
      emit(LocalError("You are offline"));
      return;
    }

    final storageRef = FirebaseStorage.instance.ref().child("images").child(Uuid().v4());

    try {
      await storageRef.putFile(File(event.local.fotoPath!));
    } on FirebaseException catch (e) {
      emit(LocalError("Failed uploading image"));
      return;
    }

    final collection = FirebaseFirestore.instance.collection('/Points of Interest')
        .withConverter<Local>(
      fromFirestore: (snapshot, _) => Local.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (item, _) => item.toJson(),
    );
    
    await collection.add(event.local.copyWith(fotoPath: await storageRef.getDownloadURL()));

    add(GetAllLocals());
  }

  Future<void> _onDeleteLocal(DeleteLocal event, Emitter<LocalState> emit) async {
    if(await checkNetwork()){
      final doc = FirebaseFirestore.instance.collection('/Points of Interest').doc(event.local.docId);

      doc.delete().then(
            (doc) {
              add(GetAllLocals());
            },
        onError: (e) {
          emit(LocalError("Delete Failed"));
          add(GetAllLocals());
        },
      );
    } else {
      emit(LocalError("Delete Failed - Your are offline"));
      add(GetAllLocals());
    }
  }

  Future<void> _onGetAllLocals(GetAllLocals event, Emitter<LocalState> emit) async {
    emit(LocalLoading());

    final isOnline = await checkNetwork();

    // return all local available locals
    emit(LocalsLoaded(await _getLocalsFromHive(), true, isOnline));

    // check internet connection
    if(isOnline){
      // there is internet connection, fetch all from firebase
      final locais = await _getLocalsFromFirestore();

      // update hive
      _setLocalsToHive(locais);

      // emit new state
      emit(LocalsLoaded(locais, false, true));
    }
  }

  Future<List<Local>> _getLocalsFromHive() async{
    return localBox.values.toList();
  }

  Future<bool> _setLocalsToHive(List<Local> locais) async{
    localBox.clear();
    localBox.addAll(locais);

    return true;
  }

  Future<List<Local>> _getLocalsFromFirestore() async{
    final collection = FirebaseFirestore.instance.collection('/Points of Interest')
        .withConverter<Local>(
      fromFirestore: (snapshot, _) => Local.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (item, _) => item.toJson(),
    );

    final docs = await collection.get();

    return docs.docs.map((e) => e.data()).toList();
  }
}
