import 'package:app_flutter_map/screens/loading_screen.dart';
import 'package:app_flutter_map/screens/test_marker_screen.dart';
import 'package:app_flutter_map/services/trafic_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/blocs.dart';


void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: ((context) => GpsBloc())),
        BlocProvider(create: ((context) => LocationBloc())),
        BlocProvider(create: ((context) => MapBloc(
          locationBloc: BlocProvider.of<LocationBloc>(context)
        )) ),
        BlocProvider(create: ((context) => SearchBloc(
          trafficService: TrafficService()
        ))),
      ], 
      child: const MapApp())
  );
}

class MapApp extends StatelessWidget {
  const MapApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: TestMarkerScreen(),
      home: const LoadingScreen(),
    );
  }
}
