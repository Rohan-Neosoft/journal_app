import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_app_using_bloc/Utility/util.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Util props;

  HomeBloc({required this.props}) : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeCreateJournalButtonClickedEvent>(
        homeCreateJournalButtonClickedEvent);
    on<HomeDeleteJournalButtonClickedEvent>(
        homeDeleteJournalButtonClickedEvent);
    on<HomeEditJournalButtonClickedEvent>(homeEditJournalButtonClickedEvent);
    on<HomeWishlistJournalButtonClickedEvent>(
        homeWishlistJournalButtonClickedEvent);
    on<HomeWishlistToggleButtonClickedEvent>(
        homeWishlistToggleButtonClickedEvent);
  }

  Future<List<Map<String, dynamic>>> getUpdatedData() async {
    final data = await props.getItems();
    return data;
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    await Future.delayed(Duration(seconds: 2));
    final data = await props.getItems();
    emit(HomeLoadedSuccessState(data: await getUpdatedData()));
  }

  FutureOr<void> homeCreateJournalButtonClickedEvent(
      HomeCreateJournalButtonClickedEvent event,
      Emitter<HomeState> emit) async {
    final data = event.data;
    print("Data send fromt event $data");
    await props.addItem(data['title'], data['desc']);
    emit(HomeLoadingState());
    emit(HomeLoadedSuccessState(data: await getUpdatedData()));
  }

  FutureOr<void> homeDeleteJournalButtonClickedEvent(
      HomeDeleteJournalButtonClickedEvent event,
      Emitter<HomeState> emit) async {
    final itemID = event.id;
    await props.deleteItem(itemID);
    emit(HomeLoadedSuccessState(data: await getUpdatedData()));
  }

  FutureOr<void> homeEditJournalButtonClickedEvent(
      HomeEditJournalButtonClickedEvent event, Emitter<HomeState> emit) async {
    final id = event.id;
    final journalTitle = event.title;
    final journalDesc = event.desc;

    await props.updateItem(id, journalTitle, journalDesc, null);
    emit(HomeLoadedSuccessState(data: await getUpdatedData()));
  }

  FutureOr<void> homeWishlistJournalButtonClickedEvent(
      HomeWishlistJournalButtonClickedEvent event,
      Emitter<HomeState> emit) async {
    final data = event.id;
    final getTask = await props.getItemsById(data);
    // getTask[0]['isFav'] = 1;
    await props.updateItem(
        getTask[0]['id'], getTask[0]['title'], getTask[0]['description'], 1);
    emit(HomeLoadedSuccessState(data: await getUpdatedData()));
  }

  FutureOr<void> homeWishlistToggleButtonClickedEvent(
      HomeWishlistToggleButtonClickedEvent event,
      Emitter<HomeState> emit) async {
    final data = event.id;
    final getTask = await props.getItemsById(data);
    if (getTask[0]['isFav'] == 1) {
      await props.updateItem(
          getTask[0]['id'], getTask[0]['title'], getTask[0]['description'], 0);
    } else {
      await props.updateItem(
          getTask[0]['id'], getTask[0]['title'], getTask[0]['description'], 1);
    }

    emit(HomeLoadedSuccessState(data: await getUpdatedData()));
  }
}
