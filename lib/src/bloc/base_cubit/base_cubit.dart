import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_flutter_bloc/src/bloc/base_cubit/sr_cubit_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/failure_stream_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/progress_stream_mixin.dart';

abstract class BaseCubit<State, SR> extends Cubit<State>
    with
        SingleResultCubitMixin<State, SR>,
        ProgressStreamMixin,
        FailureStreamMixin {
  BaseCubit(super.initialState);

  @override
  emit(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  void dispose() {
    closeProgressStream();
    closeFailureStream();
  }
}
