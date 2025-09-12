part of 'base_bloc_example_screen_bloc.dart';

@immutable
abstract class BaseBlocExampleScreenState {}

final class BaseBlocExampleScreenInitial extends BaseBlocExampleScreenState {}

final class BaseBlocExampleScreenData extends BaseBlocExampleScreenState {
  final int counter;
  final int childIndex;
  BaseBlocExampleScreenData({this.counter = 0, this.childIndex = 0});
}
