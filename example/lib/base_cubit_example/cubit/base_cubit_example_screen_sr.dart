part of 'base_cubit_example_screen_cubit.dart';

@immutable
sealed class BaseCubitExampleScreenSR {}

final class BaseCubitExampleScreenSRShowDialog
    extends BaseCubitExampleScreenSR {
  final String message;

  BaseCubitExampleScreenSRShowDialog(this.message);
}

final class BaseCubitExampleScreenSRShowChildDialog
    extends BaseCubitExampleScreenSR {
  final String message;

  BaseCubitExampleScreenSRShowChildDialog(this.message);
}
