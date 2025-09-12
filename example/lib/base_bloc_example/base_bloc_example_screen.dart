import 'package:example/base_bloc_example/bloc/base_bloc_example_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

class BaseBlocExampleScreen extends StatefulWidget {
  final String title;

  const BaseBlocExampleScreen({
    required this.title,
    super.key,
  });

  @override
  State<BaseBlocExampleScreen> createState() => _BaseBlocExampleScreenState();
}

class _BaseBlocExampleScreenState extends State<BaseBlocExampleScreen>
    with
        BaseBlocState<BaseBlocExampleScreenState, BaseBlocExampleScreenBloc,
            BaseBlocExampleScreenSR, BaseBlocExampleScreen> {
  @override
  BaseBlocExampleScreenBloc createBloc() => BaseBlocExampleScreenBloc();

  @override
  void onSR(
    BuildContext context,
    BaseBlocExampleScreenSR sr,
  ) {
    if (sr is BaseBlocExampleScreenSRShowDialog) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Bloc dialog'),
            content: Text(sr.message),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void onFailure(
    BuildContext context,
    Exception failure,
  ) {
    debugPrint(failure.toString());
  }

  @override
  void onProgress(
    BuildContext context,
    BaseProgressState progress,
  ) {
    debugPrint(progress.toString());
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            blocBuilder(
              builder: (context, state) {
                return Text(
                  '${state is BaseBlocExampleScreenData ? state.counter : 0}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () =>
                blocOf(context).add(BaseBlocExampleScreenEventOnIncrement()),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: null,
            onPressed: () => blocOf(context)
                .addSr(BaseBlocExampleScreenSRShowDialog('Hello')),
            tooltip: 'Show dialog',
            child: const Icon(Icons.message),
          ),
        ],
      ),
    );
  }
}
