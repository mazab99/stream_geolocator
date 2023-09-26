import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_geolocator/repositories/geo_repository.dart';
import 'package:geolocator/geolocator.dart';

part 'geolocation_event.dart';

part 'geolocation_state.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationStates> {
  final GeoRepository _repository;

  GeolocationBloc(this._repository) : super(const GeolocationStates()) {
    on<StartGeolocation>(
      (StartGeolocation event, Emitter<GeolocationStates> emit) async {
        await emit.onEach<Position>(
          _repository.getCurrentLocation(),
          onData: (position) {
            add(UpdateGeolocation(position: position));
          },
        );
        emit(
          state.copyWith(
            geoState: RequestState.disposed,
          ),
        );
      },
      transformer: restartable(),
    );

    on<UpdateGeolocation>(
      (UpdateGeolocation event, Emitter<GeolocationStates> emit) {
        emit(
          state.copyWith(
            position: event.position,
            geoState: RequestState.loaded,
          ),
        );
      },
    );
  }
}
