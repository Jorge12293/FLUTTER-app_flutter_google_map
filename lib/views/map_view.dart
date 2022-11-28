import 'package:app_flutter_map/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final LatLng initialLocation; 
  
  const MapView({
    super.key, 
    required this.initialLocation,
    required this.polylines,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: 15,
    );
    
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (pointerMoveEvent)=>mapBloc.add(OnStopFollowingUserEvent()),
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          compassEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          polylines:polylines,
          markers: markers,
          onMapCreated: (controller) => mapBloc.add(OnMapInitiallzedEvent(controller)),
          onCameraMove: (position) => mapBloc.mapCenter=position.target,
        ),
      ),
    );

  }
}



//final CameraPosition initialCameraPosition = CameraPosition(
  //bearing: 192.8334901395799, position.Heading // Siempre poner de Cabecera
  //target: state.lastKnowLocation!,
  //tilt: 59.440717697143555,
  //tilt: 80.440717697143555, // Grado Inclinacion
  //zoom: 19.151926040649414
  // zoom: 15
//);