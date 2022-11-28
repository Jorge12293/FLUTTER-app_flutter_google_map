import 'package:animate_do/animate_do.dart';
import 'package:app_flutter_map/blocs/blocs.dart';
import 'package:app_flutter_map/helpers/show_loading_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ManualMarker extends StatelessWidget {
  const ManualMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc,SearchState>(
      builder: (context, state){
        return state.displayManualMarker
          ?  const _ManualMarkerBody()
          :  Container();
      }
    );
  }
}


class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({super.key});

  @override
  Widget build(BuildContext context) {
    
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    
    final size = MediaQuery.of(context).size;
   
    return SizedBox(
      width:size.width,
      height:size.height,
      child: Stack(
        children: [
          const Positioned(
            top: 70,
            left: 20,
            child: _BtnBack(),
          ),
          Center(
            child: Transform.translate(
              offset: const Offset(0,-22),
              child: BounceInDown(
                from: 100,
                child:const Icon(Icons.location_on_rounded,size: 50),
              )
            ),
          ),
          
          Positioned(
            bottom: 70,
            left: 40,
            child: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: MaterialButton(
                minWidth: size.width-120,
                color: Colors.black,
                elevation: 15,
                height: 50,
                shape: const StadiumBorder(),
                onPressed: () async {
                  final start = locationBloc.state.lastKnowLocation;
                  if(start == null ) return;
                  
                  final end = mapBloc.mapCenter;
                  if(end == null ) return;
                  
                  showLoadingMessage(context);
                  
                  final destinationResp = await searchBloc.getCoorsStartToEnd(start, end);
                  await mapBloc.drawRoutePolyline(destinationResp);

                  searchBloc.add(OnDeactivateManualMarkerEvent()); 
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  
                },
                child: const Text('Confirmar Destino',style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                )),
              ),
            )
          )

        ],
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration:const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
          icon:const Icon(Icons.arrow_back_ios_new,color: Colors.black),
          onPressed: (){
            BlocProvider.of<SearchBloc>(context).add(OnDeactivateManualMarkerEvent()); 
          },
        ),
      ),
    );
  }
}