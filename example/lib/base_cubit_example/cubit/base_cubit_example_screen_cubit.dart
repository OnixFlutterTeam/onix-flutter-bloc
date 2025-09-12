import 'package:flutter/foundation.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

part 'base_cubit_example_screen_sr.dart';
part 'base_cubit_example_screen_state.dart';

class BaseCubitExampleScreenCubit
    extends BaseCubit<BaseCubitExampleScreenState, BaseCubitExampleScreenSR> {
  BaseCubitExampleScreenCubit() : super(BaseCubitExampleScreenData());

  Future<void> increment() async {
    showProgress();

    int counter = state is BaseCubitExampleScreenData
        ? (state as BaseCubitExampleScreenData).counter
        : 0;

    int childIndex = state is BaseCubitExampleScreenData
        ? (state as BaseCubitExampleScreenData).childIndex
        : 0;

    emit(BaseCubitExampleScreenData(
        counter: counter + 1, childIndex: childIndex));

    onFailure(ApiFailure(ServerFailure.unknown));

    hideProgress();
  }

  Future<void> onChild(int index) async {
    emit(BaseCubitExampleScreenData(
        counter: state is BaseCubitExampleScreenData
            ? (state as BaseCubitExampleScreenData).counter
            : 0,
        childIndex: index));
  }
}
