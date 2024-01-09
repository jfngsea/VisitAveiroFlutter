import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/local_bloc.dart';
import '../bloc/local_state.dart';
import '../components/LocalCard.dart';
import '../components/loading_widget.dart';
import '../models/local.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.type, required this.pagename});

  final LocalType type;
  final String pagename;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pagename, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/city_of_aveiro.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          SafeArea(
              child: ListPageContent(type: type,),
          )
        ],
      ),
    );
  }
}


class ListPageContent extends StatelessWidget {
  const ListPageContent({super.key, required this.type});

  final LocalType type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalBloc, LocalState>(
        builder: (context, state) {
          if(state is LocalLoading || state is LocalInitial){
            return const LoadingWidget();
          }

          else if(state is LocalsLoaded){
            if(state.locais.isEmpty){
              return const Center(
                child: Text(
                  'Não existem pontos de interesse disponíveis.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              );
            }


            return SingleChildScrollView(
              child: Column(
                children: [
                  if(state.isCache)
                    Text(state.isOnline?"Using Cache, Fetching new data...":"Using Cache. You are offline.")
                  else
                    const Text("Fresh Results"),
                  ...state.locais.where((element) => element.type==type).map((e) => LocalCard(local: e))
                ],
              ),
            );
          }

          else if(state is LocalError){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            return Text(state.message);
          }
          else {
            return const Text("unkown local bloc state");
          }

        }
    );
  }
}