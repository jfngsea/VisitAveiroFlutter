import 'package:VisitAveiroFlutter/models/local.dart';

abstract class LocalState {}

class LocalInitial extends LocalState {}

class LocalLoading extends LocalState {}

class LocalsLoaded extends LocalState {
  final List<Local> locais;
  final bool isCache;
  final bool isOnline;
  LocalsLoaded(this.locais, this.isCache, this.isOnline);
}

class LocalError extends LocalState {
  final String message;
  LocalError(this.message);
}

