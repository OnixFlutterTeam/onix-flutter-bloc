part of 'base_cubit_example_screen_cubit.dart';

@immutable
abstract class BaseCubitExampleScreenState {}

final class BaseCubitExampleScreenInitial extends BaseCubitExampleScreenState {}

final class BaseCubitExampleScreenData extends BaseCubitExampleScreenState {
  final int counter;
  final int childIndex;

  BaseCubitExampleScreenData({this.counter = 0, this.childIndex = 0});
}
