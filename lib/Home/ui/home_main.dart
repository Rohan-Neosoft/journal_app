// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app_using_bloc/Home/bloc/home_bloc.dart';
import 'package:journal_app_using_bloc/Wishlist/bloc/wishlist_bloc_bloc.dart';
import 'package:journal_app_using_bloc/Wishlist/ui/wishlist.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _SqlMainState();
}

class _SqlMainState extends State<HomeMain> {
  // final WishlistBlocBloc wishlistBlocBloc = WishlistBlocBloc();

  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(HomeInitialEvent());
  }

  void _showForm(int? id, String? title, String? description) {
    if (id != null && title != null && description != null) {
      titleController.text = title;
      descriptionController.text = description;
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 100,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Title'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Description'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (id == null) {
                        String title = titleController.text;
                        final desc = descriptionController.text;
                        Map<String, dynamic> data = {
                          'title': title,
                          'desc': desc
                        };
                        BlocProvider.of<HomeBloc>(context).add(
                            HomeCreateJournalButtonClickedEvent(data: data));
                      }

                      if (id != null) {
                        String title = titleController.text;
                        final desc = descriptionController.text;
                        BlocProvider.of<HomeBloc>(context).add(
                            HomeEditJournalButtonClickedEvent(
                                id: id, title: title, desc: desc));
                      }

                      titleController.text = "";
                      descriptionController.text = "";

                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(id == null ? 'Create New' : 'Update'))
            ],
          ),
        ),
      ),
    ).whenComplete(
      () {
        titleController.clear();
        descriptionController.clear();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Journal App"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => WishlistPage()));
                },
                icon: Icon(Icons.favorite))
          ],
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
            // bloc: wishlistBlocBloc,
            listener: (context, state) {
          // if (state is NavigateToWishlistPageActionState) {
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (_) => WishlistPage()));
          // }
        }, builder: (context, state) {
          switch (state.runtimeType) {
            case HomeLoadingState:
              return Center(
                child: CircularProgressIndicator(),
              );

            case HomeLoadedSuccessState:
              final journalAppData = state as HomeLoadedSuccessState;
              return ListView.builder(
                  itemCount: journalAppData.data.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(journalAppData.data[index]['title']),
                      onDismissed: (direction) {
                        BlocProvider.of<HomeBloc>(context).add(
                            HomeDeleteJournalButtonClickedEvent(
                                id: journalAppData.data[index]['id']));
                      },
                      child: Card(
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
                                          _showForm(
                                              journalAppData.data[index]['id'],
                                              journalAppData.data[index]
                                                  ['title'],
                                              journalAppData.data[index]
                                                  ['description']),
                                        },
                                    icon: Icon(Icons.edit)),
                                // IconButton(
                                //     onPressed: () => {
                                //           BlocProvider.of<HomeBloc>(context).add(
                                //               HomeDeleteJournalButtonClickedEvent(
                                //                   id: journalAppData.data[index]
                                //                       ['id']))
                                //         },
                                //     icon: Icon(Icons.delete)),
                                BlocBuilder<HomeBloc, HomeState>(
                                  builder: (context, state) {
                                    return IconButton(
                                        onPressed: () {
                                          BlocProvider.of<HomeBloc>(context).add(
                                              HomeWishlistJournalButtonClickedEvent(
                                            id: journalAppData.data[index]
                                                ['id'],
                                          ));

                                          BlocProvider.of<HomeBloc>(context).add(
                                              HomeWishlistToggleButtonClickedEvent(
                                            id: journalAppData.data[index]
                                                ['id'],
                                          ));
                                        },
                                        icon: (journalAppData.data[index]
                                                    ['isFav'] ==
                                                1)
                                            ? Icon(Icons.favorite_sharp)
                                            : Icon(Icons.favorite_outline),
                                        color: (journalAppData.data[index]
                                                    ['isFav'] ==
                                                1)
                                            ? Colors.red
                                            : null);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });

            default:
              return SizedBox();
          }
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showForm(null, null, null),
          child: Icon(Icons.add),
        ));
  }
}



/* 
   ListView.builder(
                  itemCount: _journals.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.orange[200],
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          _journals[index]['title'],
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                        subtitle: Text(_journals[index]['description']),
                        trailing: SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () => {}, icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () => {},
                                  icon: Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    wishlistBlocBloc.add(
                                        WishlistButtonJournalClickedEvent(
                                            id: _journals[index]['id']));
                                  },
                                  icon: Icon(Icons.favorite_outline)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
*/