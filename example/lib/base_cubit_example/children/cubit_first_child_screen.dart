import 'package:example/base_cubit_example/cubit/base_cubit_example_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';

class CubitFirstChildScreen extends StatefulWidget {
  final String title;
  const CubitFirstChildScreen({
    required this.title,
    super.key,
  });

  @override
  State<CubitFirstChildScreen> createState() => _CubitFirstChildScreenState();
}

class _CubitFirstChildScreenState extends State<CubitFirstChildScreen>
    with
        BaseCubitState<BaseCubitExampleScreenState, BaseCubitExampleScreenCubit,
            BaseCubitExampleScreenSR, CubitFirstChildScreen> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: srObserver(
        context: context,
        onSR: _onSR,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              blocBuilder(
                builder: (context, state) => Text(
                  '${state is BaseCubitExampleScreenData ? state.counter : 0}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              ElevatedButton(
                  onPressed: () => cubitOf(context).onChild(1),
                  child: const Text('Go to Second Child')),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () => cubitOf(context).increment(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: null,
            onPressed: () => cubitOf(context).addSr(
                BaseCubitExampleScreenSRShowChildDialog(
                    'Hello from First Child')),
            tooltip: 'Show dialog',
            child: const Icon(Icons.message),
          ),
        ],
      ),
    );
  }

  void _onSR(
    BuildContext context,
    BaseCubitExampleScreenSR sr,
  ) {
    if (sr is BaseCubitExampleScreenSRShowChildDialog) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cubit child dialog'),
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
}
