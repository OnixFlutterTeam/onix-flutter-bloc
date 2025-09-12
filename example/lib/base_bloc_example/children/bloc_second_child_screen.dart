import 'package:example/base_bloc_example/bloc/base_bloc_example_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';

class BlocSecondChildScreen extends StatefulWidget {
  final String title;
  const BlocSecondChildScreen({
    required this.title,
    super.key,
  });

  @override
  State<BlocSecondChildScreen> createState() => _BlocSecondChildScreenState();
}

class _BlocSecondChildScreenState extends State<BlocSecondChildScreen>
    with
        BaseBlocChild<BaseBlocExampleScreenState, BaseBlocExampleScreenBloc,
            BaseBlocExampleScreenSR, BlocSecondChildScreen> {
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
                '${state is BaseBlocExampleScreenData ? state.counter : 0}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            ElevatedButton(
                onPressed: () => blocOf(context).add(
                      BaseBlocExampleScreenEventOnChild(0),
                    ),
                child: const Text('Go to First Child')),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () => blocOf(context).add(
              BaseBlocExampleScreenEventOnIncrement(),
            ),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: null,
            onPressed: () => blocOf(context).addSr(
                BaseBlocExampleScreenSRShowDialog('Hello from Second Child')),
            tooltip: 'Show dialog',
            child: const Icon(Icons.message),
          ),
        ],
      ),
    );
  }
}
