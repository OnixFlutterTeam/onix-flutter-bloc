import 'package:flutter/foundation.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

part 'base_cubit_example_screen_sr.dart';
part 'base_cubit_example_screen_state.dart';

class BaseCubitExampleScreenCubit
    extends BaseCubit<BaseCubitExampleScreenState, BaseCubitExampleScreenSR> {
  BaseCubitExampleScreenCubit() : super(BaseCubitExampleScreenInitial());

  Future<void> increment() async {
    showProgress();
    int counter = state is BaseCubitExampleScreenData
        ? (state as BaseCubitExampleScreenData).counter
        : 0;

    print('Incrementing counter');

    await Future.delayed(const Duration(seconds: 10));

    print('Delayed done');

    emit(BaseCubitExampleScreenData(counter + 1));

    onFailure(ApiFailure(ServerFailure.unknown));

    hideProgress();
  }
}
