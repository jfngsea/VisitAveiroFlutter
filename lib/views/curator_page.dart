import 'package:VisitAveiroFlutter/bloc/local_bloc.dart';
import 'package:VisitAveiroFlutter/bloc/local_event.dart';
import 'package:VisitAveiroFlutter/components/LocalCard.dart';
import 'package:VisitAveiroFlutter/views/auth/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/local_state.dart';
import '../components/loading_widget.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'add_local_page.dart';

class CuratorPage extends StatelessWidget {
  const CuratorPage({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Curator Zone', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration:  const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/city_of_aveiro.png'),
                fit: BoxFit.cover,
              ),
            ),),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Consumer<AuthProvider>(
              builder: (context, auth, child) {
                print("@accoutview photoUrl: ${auth.user?.photoURL ?? "no url"}");

                if(auth.status == AuthStatus.uninitialized || auth.status == AuthStatus.authenticating) {
                  return const Center(child: LoadingWidget(),);
                }
                if (auth.status == AuthStatus.authenticated &&
                    auth.user != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // curator name card
                      Card(
                        child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        auth.user!.displayName != null
                                            ? auth.user!.displayName!
                                            : "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(auth.user!.email!),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        tooltip: "Sing Out",
                                        onPressed: () async {
                                          await auth.signOut();
                                        },
                                        icon: const Icon(Icons.logout)
                                    ),
                                  ],
                                ),

                              ],
                            ),
                            leading: auth.user!.photoURL != null?
                            CircleAvatar(
                              backgroundImage: NetworkImage(auth.user!.photoURL ?? ""),
                            ) :
                            const CircleAvatar(
                              child: Text(''),
                            )
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Places",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          IconButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddLocalPage(userid: auth.user!.uid,),
                                  ),
                                );
                              },
                              icon: Icon(Icons.add, color: Colors.white,)
                          )
                        ],
                      ),
                      Divider(color: Colors.white,),
                      CuratorPageContent(user: auth.appuser!)
                    ],
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'User not signed in',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInPage(),
                                ),
                              );
                            },
                            child: Text("Sign In")
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

  }
}


class CuratorPageContent extends StatelessWidget {
  const CuratorPageContent({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalBloc, LocalState>(
      buildWhen: (previous, current) => true,
        builder: (context, state) {
        print("@curator bloc builder, state: ${state.toString()}");
          if(state is LocalLoading || state is LocalInitial){
            return LoadingWidget();
          }

          else if(state is LocalsLoaded){
            return Expanded(
              child: ListView(
              children: [
                if(state.isCache)
                  Text(state.isOnline?"Using Cache, Fetching new data...":"Using Cache. You are offline.")
                else
                  Text("Fresh Results"),
                ...state.locais.where((element) => element.userid==user.id).map((e) => LocalCard(local: e, onDeleteClick: (local){
                  context.read<LocalBloc>().add(DeleteLocal(local));

                },))
              ],
              ),
            );
          }
          else if(state is LocalError){
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            return Text(state.message);
          }
          else {
            return Text("unkown local bloc state");
          }

        }
    );
  }
}

