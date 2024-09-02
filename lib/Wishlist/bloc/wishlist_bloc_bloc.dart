import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'wishlist_bloc_event.dart';
part 'wishlist_bloc_state.dart';

class WishlistBlocBloc extends Bloc<WishlistBlocEvent, WishlistBlocState> {
  final props;

  WishlistBlocBloc({this.props}) : super(WishlistBlocInitial()) {
    on<WishlistInitialEvent>(wishlistInitialEvent);
    on<WishlistDeleteButtonClickedEvent>(wishlistDeleteButtonClickedEvent);
  }

  FutureOr<void> wishlistInitialEvent(
      WishlistInitialEvent event, Emitter<WishlistBlocState> emit) async {
    emit(WishListLoadingState());
    await Future.delayed(Duration(seconds: 1));
    final data = await props.getItemByisFav();
    print(data);
    emit(WishlistLoadedSuccessState(data: data));
  }

  FutureOr<void> wishlistDeleteButtonClickedEvent(
      WishlistDeleteButtonClickedEvent event,
      Emitter<WishlistBlocState> emit) async {
    final id = event.id;
    final getStoredItem = await props.getItemsById(id);
    await props.updateItem(getStoredItem[0]['id'], getStoredItem[0]['title'],
        getStoredItem[0]['description'], 0);
    final data = await props.getItemByisFav();
    emit(WishlistLoadedSuccessState(data: data));
  }
}
