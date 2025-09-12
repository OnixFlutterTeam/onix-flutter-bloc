import 'package:example/base_bloc_example/bloc/base_bloc_example_screen_bloc.dart';
import 'package:example/base_bloc_example/children/bloc_first_child_screen.dart';
import 'package:example/base_bloc_example/children/bloc_second_child_screen.dart';
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
      body: Center(
        child: blocBuilder(
          builder: (context, state) {
            switch (state) {
              case BaseBlocExampleScreenData():
                return state.childIndex == 0
                    ? const BlocFirstChildScreen(title: 'First Child Screen')
                    : const BlocSecondChildScreen(title: 'Second Child Screen');
              case BaseBlocExampleScreenInitial():
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
