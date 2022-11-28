import 'package:animate_do/animate_do.dart';
import 'package:app_flutter_map/blocs/blocs.dart';
import 'package:app_flutter_map/delegates/search_destination.dart';
import 'package:app_flutter_map/models/search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc,SearchState>(
      builder:(context, state){
        return state.displayManualMarker
        ? const SizedBox()
        : FadeInDown(
          duration:const Duration(milliseconds: 300),
          child:const _SearchBarBody());
      } 
    );
  }
}


class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({super.key});

  void onSearchResults(BuildContext context,SearchResult result) async{
    final searchBlock = BlocProvider.of<SearchBloc>(context);
    final mapBlock = BlocProvider.of<MapBloc>(context);
    final locationBlock = BlocProvider.of<LocationBloc>(context);

    if(result.manual== true){
      searchBlock.add(OnActiveManualMarkerEvent());
      return;
    }

    if(result.position != null){  

      final destination = await searchBlock.getCoorsStartToEnd(
        locationBlock.state.lastKnowLocation!, 
        result.position!
      );
      
      await mapBlock.drawRoutePolyline(destination);
    }
  } 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin:const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: GestureDetector(
          onTap: () async {
            final result = await showSearch(context: context, delegate: SearchDestination());
            if(result == null ) return;
            // ignore: use_build_context_synchronously
            onSearchResults(context,result);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0,15)
                )
              ]
            ),
            child: const Text('A donde quieres ir',style: TextStyle(color: Colors.black87)),
          ),
        ),
      ),
    );
  }
}