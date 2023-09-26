import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_geolocator/bloc/geolocation_bloc.dart';
import 'package:stream_geolocator/repositories/geo_repository.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => GeolocationBloc(
          GeoRepository(
            GeolocatorPlatform.instance,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Geolocator with Stream',
            ),
          ),
          body: const HomeView(),
        ),
      );
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    final geoBloc = context.read<GeolocationBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: BlocBuilder<GeolocationBloc, GeolocationStates>(
            builder: (context, state) {
              if (state.geoState == RequestState.loaded) {
                return Text(
                  '${state.position!.latitude}, ${state.position!.longitude}',
                );
              }
              return const Text('is not running');
            },
          ),
        ),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: () async {
            if (!_isListening) {
              final serviceEnabled =
                  await Geolocator.isLocationServiceEnabled();
              if (!serviceEnabled) {
                return;
              }
              LocationPermission permission =
                  await Geolocator.checkPermission();
              if (permission == LocationPermission.denied) {
                permission = await Geolocator.requestPermission();
                if (permission == LocationPermission.denied) {
                  return Future.error('Location permissions are denied');
                }
              }
              if (permission == LocationPermission.deniedForever) {
                // Permissions are denied forever, handle appropriately.
                return Future.error(
                  'Location permissions are permanently denied, we cannot request permissions.',
                );
              }
              setState(() {
                _isListening = !_isListening;
              });
              geoBloc.add(StartGeolocation());
            }
          },
          child: Text(_isListening ? 'is running' : 'click here'),
        ),
      ],
    );
  }
}
