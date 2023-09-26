part of 'geolocation_bloc.dart';

class GeolocationStates extends Equatable {
  final Position? position;
  final RequestState geoState;

  const GeolocationStates({
    this.position,
    this.geoState = RequestState.loading,
  });

  GeolocationStates copyWith({
    Position? position,
    RequestState? geoState,
  }) {
    return GeolocationStates(
      position: position ?? this.position,
      geoState: geoState ?? this.geoState,
    );
  }

  @override
  List<Object?> get props => [position, geoState];
}

enum RequestState {
  loading,
  loaded,
  error,
  disposed,
}
