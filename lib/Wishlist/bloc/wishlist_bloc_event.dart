part of 'wishlist_bloc_bloc.dart';

@immutable
sealed class WishlistBlocEvent {}

class WishlistInitialEvent extends WishlistBlocEvent {}

class WishlistButtonJournalClickedEvent extends WishlistBlocEvent {
  final int id;

  WishlistButtonJournalClickedEvent({required this.id});
}

class WishlistDeleteButtonClickedEvent extends WishlistBlocEvent {
  final int id;

  WishlistDeleteButtonClickedEvent({required this.id});
}
