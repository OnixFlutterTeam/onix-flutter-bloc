import 'package:example/base_bloc_example/bloc/base_bloc_example_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';

class BlocFirstChildScreen extends StatefulWidget {
  final String title;
  const BlocFirstChildScreen({
    required this.title,
    super.key,
  });

  @override
  State<BlocFirstChildScreen> createState() => _BlocFirstChildScreenState();
}

class _BlocFirstChildScreenState extends State<BlocFirstChildScreen>
    with
        BaseBlocChild<BaseBlocExampleScreenState, BaseBlocExampleScreenBloc,
            BaseBlocExampleScreenSR, BlocFirstChildScreen> {
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
                      BaseBlocExampleScreenEventOnChild(1),
                    ),
                child: const Text('Go to Second Child')),
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
            onPressed: () => blocOf(context).addSr(
                BaseBlocExampleScreenSRShowDialog('Hello from First Child')),
            tooltip: 'Show dialog',
            child: const Icon(Icons.message),
          ),
        ],
      ),
    );
  }
}
