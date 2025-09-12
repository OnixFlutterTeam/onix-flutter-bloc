import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onix_flutter_bloc/src/bloc/base_cubit/base_cubit.dart';
import 'package:onix_flutter_bloc/src/bloc/bloc_typedefs.dart';
import 'package:onix_flutter_bloc/src/bloc/stream_listener.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

mixin BaseCubitChild<S, C extends BaseCubit<S, SR>, SR,
    W extends StatefulWidget> on State<W> {
  C? _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<C>.value(
      value: cubitOf(context),
      child: Builder(
        builder: (context) {
          return buildWidget(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
    super.dispose();
  }

  C cubitOf(BuildContext context) => context.read<C>();

  Widget srObserver({
    required BuildContext context,
    required Widget child,
    required SingleResultListener<SR> onSR,
  }) {
    return StreamListener<SR>(
      stream: (_cubit ?? cubitOf(context)).singleResults,
      onData: (data) {
        onSR(context, data);
      },
      child: child,
    );
  }

  void onFailure(BuildContext context, Exception failure) {}

  void onSR(BuildContext context, SR sr) {}

  void onProgress(BuildContext context, BaseProgressState progress) {
    if (progress is DefaultProgressState) {
      if (progress.showProgress) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    }
  }

  Widget buildWidget(BuildContext context);

  Widget blocConsumer({
    required StateListener<S> builder,
    required ListenDelegate<S> listener,
    BlocBuilderCondition<S>? buildWhen,
    BlocListenerCondition<S>? listenWhen,
  }) {
    return BlocConsumer<C, S>(
      builder: (_, state) => builder(state),
      listener: listener,
      buildWhen: buildWhen,
      listenWhen: listenWhen,
    );
  }

  Widget blocBuilder({
    required BlocWidgetBuilder<S> builder,
    BlocBuilderCondition<S>? buildWhen,
  }) {
    return BlocBuilder<C, S>(builder: builder, buildWhen: buildWhen);
  }

  Widget blocListener({
    required ListenDelegate<S> listener,
    Widget? child,
    BlocListenerCondition<S>? listenWhen,
  }) {
    return BlocListener<C, S>(
      listener: listener,
      listenWhen: listenWhen,
      child: child,
    );
  }
}
