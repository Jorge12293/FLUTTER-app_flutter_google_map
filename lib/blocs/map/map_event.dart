part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}


class OnMapInitiallzedEvent extends MapEvent{
  final GoogleMapController controller;
  const OnMapInitiallzedEvent(this.controller);
}

class OnStopFollowingUserEvent extends MapEvent{}
class OnStartFollowingUserEvent extends MapEvent{}

class UpdateUserPolilyneEvent extends MapEvent{
  final List<LatLng> userLocations;
  const UpdateUserPolilyneEvent(this.userLocations);
}

class OnToggleUserRoute extends MapEvent{}


class DisplayPolylinsEvent extends MapEvent {
  final Map<String,Polyline> polylines;
  final Map<String,Marker> markers;
  const DisplayPolylinsEvent(this.polylines,this.markers);
}