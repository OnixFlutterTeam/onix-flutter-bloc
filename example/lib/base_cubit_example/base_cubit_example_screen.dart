import 'package:example/base_cubit_example/cubit/base_cubit_example_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

import 'children/cubit_first_child_screen.dart';
import 'children/cubit_second_child_screen.dart';

class BaseCubitExampleScreen extends StatefulWidget {
  final String title;

  const BaseCubitExampleScreen({
    required this.title,
    super.key,
  });

  @override
  State<BaseCubitExampleScreen> createState() => _BaseCubitExampleScreenState();
}

class _BaseCubitExampleScreenState extends State<BaseCubitExampleScreen>
    with
        BaseCubitState<BaseCubitExampleScreenState, BaseCubitExampleScreenCubit,
            BaseCubitExampleScreenSR, BaseCubitExampleScreen> {
  @override
  BaseCubitExampleScreenCubit createCubit() => BaseCubitExampleScreenCubit();

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Center(
        child: blocBuilder(
          builder: (context, state) {
            switch (state) {
              case BaseCubitExampleScreenData():
                return state.childIndex == 0
                    ? const CubitFirstChildScreen(title: 'First Child Screen')
                    : const CubitSecondChildScreen(
                        title: 'Second Child Screen');
              case BaseCubitExampleScreenInitial():
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  @override
  void onSR(
    BuildContext context,
    BaseCubitExampleScreenSR sr,
  ) {
    if (sr is BaseCubitExampleScreenSRShowDialog) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cubit dialog'),
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
}
