import 'package:project_test/models/local.dart';

abstract class LocalState {}

class LocalInitial extends LocalState {}

class LocalLoading extends LocalState {}

class LocalsLoaded extends LocalState {
  final List<Local> locais;
  LocalsLoaded(this.locais);
}

class LocalError extends LocalState {
  final String message;
  LocalError(this.message);
}
