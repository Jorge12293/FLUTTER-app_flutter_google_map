
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class GpsAccesScreen extends StatelessWidget {
  const GpsAccesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:BlocBuilder<GpsBloc,GpsState>(
          builder:(context,state){
            return !state.isGpsEnabled
            ? const _EnabledGpsMessage()
            : const _AccesButton();
          
          }        
        )
      ),
    );
  }
}

class _AccesButton extends StatelessWidget {
  const _AccesButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario el acceso a GPS'),
        MaterialButton(
          color: Colors.black,
          shape: const StadiumBorder(),
          elevation: 5,
          splashColor: Colors.transparent,
          onPressed: (){
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();
          },
          child: const Text('Solicitar Acceso',
          style: TextStyle(color: Colors.white)))
      ],
    );
  }
}

class _EnabledGpsMessage extends StatelessWidget {
  const _EnabledGpsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Debe habilitar el GPS',
    style: TextStyle(fontSize: 25,fontWeight: FontWeight.w300));
  }
}