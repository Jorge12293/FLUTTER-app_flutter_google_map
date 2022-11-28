import 'package:app_flutter_map/blocs/blocs.dart';
import 'package:app_flutter_map/screens/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc,GpsState>(
        builder: (context,state){
          return state.isAllGranted
          ? MapScreen()
          : GpsAccesScreen();
        },
      ),
    );
  }
}