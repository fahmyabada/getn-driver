part of 'splash_screen_cubit.dart';

@immutable
abstract class SplashScreenState {}

class SplashScreenInitial extends SplashScreenState {}

class StartState extends SplashScreenState {
  final String message;

  StartState(this.message);
}