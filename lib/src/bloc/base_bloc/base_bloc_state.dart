import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_flutter_bloc/src/bloc/base_bloc/base_bloc.dart';
import 'package:onix_flutter_bloc/src/bloc/bloc_typedefs.dart';
import 'package:onix_flutter_bloc/src/bloc/stream_listener.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

mixin BaseBlocState<S, B extends BaseBloc<dynamic, S, SR>, SR,
    W extends StatefulWidget> on State<W> {
  bool _listenersAttached = false;
  bool lazyBloc = false;
  B? _bloc;

  bool _hasParentBloc = false;

  B? get bloc => _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = _getCurrentBloc(context);
    if (_bloc != null) {
      _hasParentBloc = true;
      return BlocProvider<B>.value(
        value: _bloc ?? blocOf(context),
        child: Builder(
          builder: (context) {
            initParams(context);
            onBlocReady(context, _bloc!);
            return buildWidget(context);
          },
        ),
      );
    }

    return BlocProvider<B>(
      create: (context) {
        final bloc = createBloc();
        _bloc = bloc;
        return bloc;
      },
      lazy: lazyBloc,
      child: Builder(
        builder: (context) {
          if (_bloc != null) {
            if (!_listenersAttached) {
              _listenersAttached = true;
              _attachListeners(context);
            }
            onBlocCreated(context, _bloc!);
            onBlocReady(context, _bloc!);
          }
          initParams(context);
          return buildWidget(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_bloc != null && !_hasParentBloc) {
      _bloc?.dispose();
    }
    super.dispose();
  }

  B? _getCurrentBloc(BuildContext context) {
    try {
      return BlocProvider.of<B>(context);
    } catch (e) {
      return null;
    }
  }

  B blocOf(BuildContext context) => context.read<B>();

  B createBloc() => throw UnimplementedError(
        'createBloc() must be implemented if you are not '
        'providing a bloc from above the widget tree.',
      );

  Widget srObserver({
    required BuildContext context,
    required Widget child,
    required SingleResultListener<SR> onSR,
  }) {
    return StreamListener<SR>(
      stream: (_bloc ?? blocOf(context)).singleResults,
      onData: (data) {
        onSR(context, data);
      },
      child: child,
    );
  }

  void onBlocReady(BuildContext context, B bloc) {}

  @deprecated
  void onBlocCreated(BuildContext context, B bloc) {}

  void onFailure(BuildContext context, Exception failure) {}

  void onSR(BuildContext context, SR sr) {}

  void onProgress(BuildContext context, BaseProgressState progress) {}

  // ignore: no-empty-block
  @deprecated
  void initParams(BuildContext context) {}

  Widget buildWidget(BuildContext context);

  void _attachListeners(BuildContext context) {
    _bloc?.failureStream.listen((failure) {
      if (!context.mounted) return;
      onFailure(context, failure);
    });

    _bloc?.singleResults.listen((sr) {
      if (!context.mounted) return;
      onSR(context, sr);
    });

    _bloc?.progressStream.listen((progress) {
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
    return BlocConsumer<B, S>(
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
    return BlocBuilder<B, S>(builder: builder, buildWhen: buildWhen);
  }

  Widget blocListener({
    required ListenDelegate<S> listener,
    Widget? child,
    BlocListenerCondition<S>? listenWhen,
  }) {
    return BlocListener<B, S>(
      listener: listener,
      listenWhen: listenWhen,
      child: child,
    );
  }
}
