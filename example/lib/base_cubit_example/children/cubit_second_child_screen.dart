import 'package:example/base_cubit_example/cubit/base_cubit_example_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';

class CubitSecondChildScreen extends StatefulWidget {
  final String title;
  const CubitSecondChildScreen({
    required this.title,
    super.key,
  });

  @override
  State<CubitSecondChildScreen> createState() => _CubitSecondChildScreenState();
}

class _CubitSecondChildScreenState extends State<CubitSecondChildScreen>
    with
        BaseCubitChild<BaseCubitExampleScreenState, BaseCubitExampleScreenCubit,
            BaseCubitExampleScreenSR, CubitSecondChildScreen> {
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
              builder: (context, state) => Text(
                '${state is BaseCubitExampleScreenData ? state.counter : 0}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            ElevatedButton(
                onPressed: () => cubitOf(context).onChild(0),
                child: const Text('Go to First Child')),
          ],
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
                BaseCubitExampleScreenSRShowDialog('Hello from Second Child')),
            tooltip: 'Show dialog',
            child: const Icon(Icons.message),
          ),
        ],
      ),
    );
  }
}
