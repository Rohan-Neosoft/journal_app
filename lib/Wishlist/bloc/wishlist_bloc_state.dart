part of 'wishlist_bloc_bloc.dart';

@immutable
sealed class WishlistBlocState {}

final class WishlistBlocInitial extends WishlistBlocState {}

class WishListLoadingState extends WishlistBlocState {}

class WishlistLoadedSuccessState extends WishlistBlocState {
  final List<Map<String, dynamic>> data;

  WishlistLoadedSuccessState({required this.data});
}

class WishListErrorState extends WishlistBlocState {}
