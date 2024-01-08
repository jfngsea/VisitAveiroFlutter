import 'package:VisitAveiroFlutter/models/local.dart';

abstract class LocalEvent {}

class AddLocal extends LocalEvent {
  final Local local;
  AddLocal(this.local);
}

class DeleteLocal extends LocalEvent {
  final Local local;
  DeleteLocal(this.local);
}

class GetAllLocals extends LocalEvent {
  GetAllLocals();
}

// Outros eventos como UpdateLocal, DeleteLocal, etc., conforme necessário
