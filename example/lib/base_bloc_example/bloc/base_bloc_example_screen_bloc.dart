import 'package:flutter/foundation.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

part 'base_bloc_example_screen_event.dart';
part 'base_bloc_example_screen_sr.dart';
part 'base_bloc_example_screen_state.dart';

class BaseBlocExampleScreenBloc extends BaseBloc<BaseBlocExampleScreenEvent,
    BaseBlocExampleScreenState, BaseBlocExampleScreenSR> {
  BaseBlocExampleScreenBloc() : super(BaseBlocExampleScreenInitial()) {
    on<BaseBlocExampleScreenEventOnIncrement>((event, emit) async {
      showProgress();

      int counter = state is BaseBlocExampleScreenData
          ? (state as BaseBlocExampleScreenData).counter
          : 0;

      print('Incrementing counter');

      await Future.delayed(const Duration(seconds: 10));

      print('Delayed done');

      emit(BaseBlocExampleScreenData(counter + 1));

      onFailure(ApiFailure(ServerFailure.unknown));

      hideProgress();
    });
  }
}
