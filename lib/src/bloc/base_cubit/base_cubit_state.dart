import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onix_flutter_bloc/src/bloc/base_cubit/base_cubit.dart';
import 'package:onix_flutter_bloc/src/bloc/bloc_typedefs.dart';
import 'package:onix_flutter_bloc/src/bloc/stream_listener.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

mixin BaseCubitState<S, C extends BaseCubit<S, SR>, SR,
    W extends StatefulWidget> on State<W> {
  bool _listenersAttached = false;
  bool lazyCubit = false;
  C? _cubit;

  C? get cubit => _cubit;

  @override
  Widget build(BuildContext context) {
    _cubit = _getCurrentCubit(context);
    if (_cubit != null) {
      return BlocProvider<C>.value(
        value: _cubit ?? cubitOf(context),
        child: Builder(
          builder: (context) {
            initParams(context);
            return buildWidget(context);
          },
        ),
      );
    }

    return BlocProvider<C>(
      create: (context) {
        final cubit = createCubit();
        _cubit = cubit;
        return cubit;
      },
      lazy: lazyCubit,
      child: Builder(
        builder: (context) {
          if (_cubit != null) {
            if (!_listenersAttached) {
              _listenersAttached = true;
              _attachListeners(context);
            }
            onCubitCreated(context, _cubit!);
          }
          initParams(context);
          return buildWidget(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_cubit != null) {
      _cubit?.dispose();
    }
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
    super.dispose();
  }

  C? _getCurrentCubit(BuildContext context) {
    try {
      return BlocProvider.of<C>(context);
    } catch (e) {
      return null;
    }
  }

  C cubitOf(BuildContext context) => context.read<C>();

  C createCubit() => throw UnimplementedError(
        'createCubit() must be implemented if you are not '
        'providing a cubit from above the widget tree.',
      );

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

  void onCubitCreated(BuildContext context, C cubit) {}

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

  // ignore: no-empty-block
  void initParams(BuildContext context) {}

  Widget buildWidget(BuildContext context);

  void _attachListeners(BuildContext context) {
    _cubit?.failureStream.listen((failure) {
      if (!context.mounted) return;
      onFailure(context, failure);
    });

    _cubit?.singleResults.listen((sr) {
      if (!context.mounted) return;
      onSR(context, sr);
    });

    _cubit?.progressStream.listen((progress) {
      if (!context.mounted) return;
      onProgress(context, progress);
    });
  }

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
