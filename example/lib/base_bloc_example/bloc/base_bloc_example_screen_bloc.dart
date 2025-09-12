import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

part 'base_bloc_example_screen_event.dart';
part 'base_bloc_example_screen_sr.dart';
part 'base_bloc_example_screen_state.dart';

class BaseBlocExampleScreenBloc extends BaseBloc<BaseBlocExampleScreenEvent,
    BaseBlocExampleScreenState, BaseBlocExampleScreenSR> {
  BaseBlocExampleScreenBloc() : super(BaseBlocExampleScreenData()) {
    on<BaseBlocExampleScreenEventOnIncrement>(_onIncrement);
    on<BaseBlocExampleScreenEventOnChild>(_onChild);
  }

  Future<void> _onIncrement(
    BaseBlocExampleScreenEventOnIncrement event,
    Emitter<BaseBlocExampleScreenState> emit,
  ) async {
    showProgress();

    int counter = state is BaseBlocExampleScreenData
        ? (state as BaseBlocExampleScreenData).counter
        : 0;

    int childIndex = state is BaseBlocExampleScreenData
        ? (state as BaseBlocExampleScreenData).childIndex
        : 0;

    emit(BaseBlocExampleScreenData(
        counter: counter + 1, childIndex: childIndex));

    onFailure(ApiFailure(ServerFailure.unknown));

    hideProgress();
  }

  Future<void> _onChild(
    BaseBlocExampleScreenEventOnChild event,
    Emitter<BaseBlocExampleScreenState> emit,
  ) async {
    showProgress();

    int counter = state is BaseBlocExampleScreenData
        ? (state as BaseBlocExampleScreenData).counter
        : 0;

    emit(BaseBlocExampleScreenData(counter: counter, childIndex: event.index));

    hideProgress();
  }
}
