part of 'geolocation_bloc.dart';

abstract class GeolocationEvent extends Equatable {
  const GeolocationEvent();

  @override
  List<Object> get props => [];
}

class StartGeolocation extends GeolocationEvent {}

class UpdateGeolocation extends GeolocationEvent {
  final Position position;

  const UpdateGeolocation({required this.position});

  @override
  List<Object> get props => [position];
}

class CompleteGeolocation extends GeolocationEvent {}
