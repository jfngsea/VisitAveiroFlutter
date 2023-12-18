import 'package:VisitAveiroFlutter/models/local.dart';

abstract class LocalEvent {}

class AddLocal extends LocalEvent {
  final Local local;
  AddLocal(this.local);
}

// Outros eventos como UpdateLocal, DeleteLocal, etc., conforme necessário
