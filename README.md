This package contains some base classes designed to improve experience of using BLoC state
management.

### BLoC (Cubit)

Custom BLoC is a regular BLoC with an additional event type called Single Result. Single Result is
designed to call single time function in the UI (like show dialog, navigation, etc.).

Extend you BLoC class from `BaseBloc`:

```
class ExampleScreenBloc extends BaseBloc<BlocEvent,
    BlocState, BlocSR>
```

Extend you widget from `BaseState`

```
class _ExampleScreenState extends State<ExampleScreen> with BaseBlocState<BlocState,
    ExampleScreenBloc, BlocSR, ExampleScreen> {
```

Create BLoC instance in `createBloc` function (not necessary if parent widget provides this BLoC):

```
 ExampleScreenBloc createBloc() => ExampleScreenBloc();
```

Write you widget body in `buildWidget` instead of `build`

```
  @override
  Widget buildWidget(BuildContext context) {
  	return Scaffold(...);
  }
```

Use integrated widgets to handle Single result events or state:

```
srObserver(
    context: context,
    onSR: (BuildContext context, BlocSR sr) {
    ...
    },
    child: Scaffold(...),
);
```

or you can override the onSR method (don't do it for children):

```
@override
void onSR(
  BuildContext context,
  ExambleBloc bloc,
  BlocSR sr,
) {
  ...
}
```

It is also possible to override the onFailure method to handle failure objects:

```
@override
void onFailure(
  BuildContext context,
  ExampleBloc bloc,
  Exception failure,
) {
  ...
}
```

and even onProgress to implement custom progress state behaviour:

```
@override
void onProgress(
  BuildContext context,
  ExampleBloc bloc,
  BaseProgressState progress,
) {
  ...
}
```

The `blocBuilder` method is used to create a widget in response to new states:

```
blocBuilder(
    builder: (BuildContext context, BlocState state) => MyWidget(...),
}
```

The `blocListener` method is used to respond to changes in bloc state:

```
blocListener(
      listener: (context, state) => print(state),
      listenWhen: (prev, curr) => prev != curr,
      child: MyWidget(...),
)      
```

The `blocConsumer` exposes a builder and listener in order react to new states:

```
blocConsumer(
      listener: (context, state) => print(state),
      builder: (context, state) => MyWidget(...),
      listenWhen: (prev, curr) => prev != curr,
      buildWhen: (prev, curr) => prev != curr,
)
```

You can also use the widget classes `BlocBuilder`, `BlocListener`, `BlocConsumer` from
the `flutter_bloc` package without any restrictions
