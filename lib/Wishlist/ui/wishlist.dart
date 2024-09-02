// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app_using_bloc/Home/bloc/home_bloc.dart';
import 'package:journal_app_using_bloc/Wishlist/bloc/wishlist_bloc_bloc.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WishlistBlocBloc>(context).add(WishlistInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Important Points"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            BlocProvider.of<HomeBloc>(context).add(HomeInitialEvent());
          },
        ),
      ),
      body: BlocConsumer<WishlistBlocBloc, WishlistBlocState>(
        listener: (context, state) {
          // if (state is WishListProductRemoveState) {
          //   ScaffoldMessenger.of(context)
          //       .showSnackBar(SnackBar(content: Text('Item Removed')));
          // }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case WishListLoadingState:
              return Center(child: CircularProgressIndicator());

            case WishlistLoadedSuccessState:
              final journalAppData = state as WishlistLoadedSuccessState;
              return ListView.builder(
                  itemCount: journalAppData.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.orange[200],
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          journalAppData.data[index]['title'],
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                        subtitle: Text(
                            journalAppData.data[index]['description'] ?? " "),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () => {
                                        BlocProvider.of<WishlistBlocBloc>(
                                                context)
                                            .add(
                                                WishlistDeleteButtonClickedEvent(
                                                    id: journalAppData
                                                        .data[index]['id']))
                                      },
                                  icon: Icon(Icons.remove)),
                            ],
                          ),
                        ),
                      ),
                    );
                  });

            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}
