import 'dart:async';
import 'dart:convert';
import 'package:app_flutter_map/blocs/blocs.dart';
import 'package:app_flutter_map/helpers/custom_image_markers.dart';
import 'package:app_flutter_map/helpers/widget_to_marker.dart';
import 'package:app_flutter_map/models/route_destination.dart';
import 'package:app_flutter_map/themes/map_light_theme.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;
   
  StreamSubscription<LocationState>? locationStateSubscription; 

  MapBloc({
    required this.locationBloc
  }) : super(const MapState()) {
    
    on<OnMapInitiallzedEvent>(_onInitMap);

    on<OnStartFollowingUserEvent>(_onStartFollowingUser);
    on<OnStopFollowingUserEvent>((event, emit) => emit(state.copyWith(isFollowingUser: false)));
    on<UpdateUserPolilyneEvent>(_onPolylineNewPoint);
    on<OnToggleUserRoute>((event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));
    on<DisplayPolylinsEvent>((event, emit) => emit(state.copyWith(polylines:event.polylines,markers: event.markers)));
    

    locationStateSubscription = locationBloc.stream.listen((locationState) {   

      if(locationState.lastKnowLocation !=null){
        add(UpdateUserPolilyneEvent(locationState.myLocationHistory));
      }

      if(!state.isFollowingUser) return;
      if(locationState.lastKnowLocation== null)  return;
      moveCamera(locationState.lastKnowLocation!);
    });

  }

  void _onInitMap(OnMapInitiallzedEvent event,Emitter<MapState> emit){
   
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(mapLightTheme));
    emit(state.copyWith(isMapInitialized: true));
  
  }

  void _onStartFollowingUser(OnStartFollowingUserEvent event,Emitter<MapState> emit){
    emit(state.copyWith(isFollowingUser: true));
    if(locationBloc.state.lastKnowLocation == null) return;
    moveCamera(locationBloc.state.lastKnowLocation!);
  }


  void _onPolylineNewPoint(UpdateUserPolilyneEvent event,Emitter<MapState> emit){
    final myRoute =Polyline(
      polylineId: const PolylineId('myRoute'),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations
    );

    final currentPolylines = Map<String,Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawRoutePolyline(RouteDestination destination) async{
  
    

    //final startMarkerIcon = await getAssetImageMarker();
    //final endMarkerIcon = await getNetworkImageMarker();

    double kms = destination.distance / 1000;
    kms = ( kms * 100 ).floorToDouble();
    kms /= 100;
   
    int tripDuration = ( destination.duration / 60 ).floorToDouble().toInt();

    final startMarkerIcon = await getStartCustomMarker(tripDuration,'My Ubicacion');
    final endMarkerIcon = await getEndCustomMarker(kms.toInt(),destination.endPlace.text);


    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      width: 5,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap
    );
    
    final curretPolylines = Map<String, Polyline>.from(state.polylines);
    curretPolylines['route']= myRoute;

    final satartMarker= Marker(
      anchor: const Offset(0.1, 1),
      markerId: const MarkerId('start'),
      position: destination.points.first,
      icon: startMarkerIcon,
      infoWindow: InfoWindow(
        title: 'Inicio',
        snippet: 'Kms: $kms , duration: $tripDuration'
      )
    );

    final endMarker= Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,
      icon: endMarkerIcon,
      infoWindow: InfoWindow(
        title: destination.endPlace.text,
        snippet: destination.endPlace.placeName
      )
    );

    final currentMarkers = Map<String,Marker>.from(state.markers);
    currentMarkers['start']=satartMarker;
    currentMarkers['end']=endMarker;

    add(DisplayPolylinsEvent(curretPolylines,currentMarkers));

    // await Future.delayed(const Duration(milliseconds: 3000));
    // _mapController?.showMarkerInfoWindow(const MarkerId('start'));

  }


  void moveCamera(LatLng newLocation){
    try{
      final cameraUpdate = CameraUpdate.newLatLng(newLocation);
      _mapController!.animateCamera(cameraUpdate);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }

}
