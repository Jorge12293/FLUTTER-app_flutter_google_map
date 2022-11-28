



import 'package:app_flutter_map/models/places_models.dart';
import 'package:app_flutter_map/models/traffic_response.dart';
import 'package:app_flutter_map/services/places_interceptor.dart';
import 'package:app_flutter_map/services/traffic_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrafficService{
  
  final Dio _dioTraffic;
  final Dio _dioPlaces;

  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  final String _basePlacesUrl  = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
  
  TrafficService()
    : _dioTraffic = Dio()..interceptors.add( TrafficInterceptor() ),
      _dioPlaces = Dio()..interceptors.add( PlacesInterceptor() );

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start,LatLng end) async{
    final coordString ='${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '$_baseTrafficUrl/driving/$coordString';
    final resp = await _dioTraffic.get(url);
    final data = TrafficResponse.fromMap(resp.data);
    return data;
  }

  Future<List<Feature>> getResultsByQuery( LatLng proximity, String query ) async {

    if ( query.isEmpty ) return [];
    final url = '$_basePlacesUrl/$query.json';
    final resp = await _dioPlaces.get(url, 
    queryParameters: {
      'proximity': '${ proximity.longitude },${ proximity.latitude }',
      'limit':7
    });

    //final placesResponse = PlacesResponse.fromJson( resp.data );
    final placesResponse = PlacesResponse.fromMap(resp.data);
    return placesResponse.features;
  }

    Future<Feature> getInformationByCoors( LatLng coors) async {

    final url = '$_basePlacesUrl/${coors.longitude},${coors.latitude}.json';
    final resp = await _dioPlaces.get(url,queryParameters: {
      'limit': 1
    });

    final placesResponse = PlacesResponse.fromMap(resp.data);
    return placesResponse.features[0];
  }

}

