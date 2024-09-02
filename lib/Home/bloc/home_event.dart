part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeCreateJournalButtonClickedEvent extends HomeEvent {
  final Map<String, dynamic> data;

  HomeCreateJournalButtonClickedEvent({required this.data});
}

class HomeEditJournalButtonClickedEvent extends HomeEvent {
  final int id;
  final String title;
  final dynamic desc;

  HomeEditJournalButtonClickedEvent(
      {required this.id, required this.title, required this.desc});
}

class HomeDeleteJournalButtonClickedEvent extends HomeEvent {
  final int id;

  HomeDeleteJournalButtonClickedEvent({required this.id});
}

class HomeWishlistJournalButtonClickedEvent extends HomeEvent {
  final int id;

  HomeWishlistJournalButtonClickedEvent({required this.id});
}

class HomeWishlistToggleButtonClickedEvent extends HomeEvent {
  final int id;

  HomeWishlistToggleButtonClickedEvent({required this.id});
}
