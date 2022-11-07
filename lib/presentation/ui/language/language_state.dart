part of 'language_cubit.dart';

@immutable
abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageEnState extends LanguageState {
  final bool isEn;

  LanguageEnState(this.isEn);
}