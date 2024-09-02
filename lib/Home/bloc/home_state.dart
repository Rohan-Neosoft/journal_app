part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

// States that will build UI
class HomeLoadingState extends HomeState {}

class HomeLoadedSuccessState extends HomeState {
  final List<Map<String, dynamic>> data;

  HomeLoadedSuccessState({required this.data});
}

class HomeToggleState extends HomeState {}

class HomeToggleSuccessState extends HomeState {}

class HomeErrorState extends HomeState {}
