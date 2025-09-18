import 'package:example/base_cubit_example/base_cubit_example_screen.dart';
import 'package:example/base_cubit_example/children/cubit_first_child_screen.dart';
import 'package:example/base_cubit_example/children/cubit_second_child_screen.dart';
import 'package:example/base_cubit_example/cubit/base_cubit_example_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';

void main() {
  group('BaseCubitExampleScreen Widget Tests', () {
    Widget createTestWidget() {
      return MaterialApp(
        home: const BaseCubitExampleScreen(
          title: 'Test Screen',
        ),
      );
    }

    Future<BaseCubitExampleScreenCubit?> init(
      WidgetTester tester,
      BaseCubitExampleScreenState emitState,
    ) async {
      await tester.pumpWidget(createTestWidget());

      final cubit =
          (tester.state(find.byType(BaseCubitExampleScreen)) as BaseCubitState)
              .cubit as BaseCubitExampleScreenCubit?;

      cubit?.emit(emitState);

      return cubit;
    }

    testWidgets('should display loading indicator initially', (tester) async {
      // Act
      final cubit = await init(tester, BaseCubitExampleScreenInitial());

      await tester.pump();

      // Assert
      expect(cubit, isNotNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(CubitFirstChildScreen), findsNothing);
      expect(find.byType(CubitSecondChildScreen), findsNothing);
    });

    testWidgets('should display First Child', (tester) async {
      // Act
      final cubit = await init(tester, BaseCubitExampleScreenData());

      await tester.pump();

      // Assert
      expect(cubit, isNotNull);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(CubitFirstChildScreen), findsOneWidget);
      expect(find.byType(CubitSecondChildScreen), findsNothing);

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should display Second Child', (tester) async {
      // Act
      final cubit = await init(tester, BaseCubitExampleScreenData());

      await tester.tap(
        find.ancestor(
          of: find.text('Go to Second Child'), // Find the Text widget first
          matching: find
              .byType(ElevatedButton), // Then find its ElevatedButton ancestor
        ),
      );

      await tester.pump();

      // Assert
      expect(cubit, isNotNull);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(CubitFirstChildScreen), findsNothing);
      expect(find.byType(CubitSecondChildScreen), findsOneWidget);

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should increment counter on button press', (tester) async {
      // Act
      final cubit = await init(tester, BaseCubitExampleScreenData());

      // Assert initial state
      expect(cubit, isNotNull);
      expect(find.text('0'), findsOneWidget);

      // Act - Tap increment button
      await tester.tap(find.byTooltip('Increment'));
      await tester.pumpAndSettle();

      // Assert incremented state
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Should persist counter after child switch', (tester) async {
      // Act
      final cubit = await init(tester, BaseCubitExampleScreenData(counter: 5));

      await tester.pump();

      // Assert initial state
      expect(cubit, isNotNull);
      expect(find.text('5'), findsOneWidget);
      expect(find.byType(CubitFirstChildScreen), findsOneWidget);
      expect(find.byType(CubitSecondChildScreen), findsNothing);

      // Act - Tap increment button
      await tester.tap(
        find.ancestor(
          of: find.text('Go to Second Child'), // Find the Text widget first
          matching: find
              .byType(ElevatedButton), // Then find its ElevatedButton ancestor
        ),
      );

      await tester.pumpAndSettle();

      // Assert incremented state
      expect(find.text('5'), findsOneWidget);
      expect(find.byType(CubitFirstChildScreen), findsNothing);
      expect(find.byType(CubitSecondChildScreen), findsOneWidget);
    });

    testWidgets('Should show correct dialogs', (tester) async {
      // Act
      final cubit = await init(tester, BaseCubitExampleScreenData());

      await tester.pump();

      Finder findDialog(String text) => find.descendant(
            of: find.byType(AlertDialog),
            matching: find.text(text),
          );

      // Assert initial state
      expect(cubit, isNotNull);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(CubitFirstChildScreen), findsOneWidget);
      expect(find.byType(CubitSecondChildScreen), findsNothing);

      // Act - Tap show dialog button
      await tester.tap(
        find.ancestor(
          of: find.byIcon(Icons.message),
          matching: find.byType(FloatingActionButton),
        ),
      );
      await tester.pumpAndSettle();

      // Assert dialog shown
      expect(findDialog('Cubit child dialog'), findsOneWidget);
      expect(findDialog('Hello from First Child'), findsOneWidget);

      // Act - Close dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Assert dialog closed
      expect(findDialog('Cubit child dialog'), findsNothing);
      expect(findDialog('Hello from First Child'), findsNothing);

      // Act - Navigate to second child and show its dialog
      await tester.tap(
        find.ancestor(
          of: find.text('Go to Second Child'),
          matching: find.byType(ElevatedButton),
        ),
      );
      await tester.pumpAndSettle();

      // Assert on second child
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(CubitFirstChildScreen), findsNothing);
      expect(find.byType(CubitSecondChildScreen), findsOneWidget);

      await tester.tap(
        find.ancestor(
          of: find.byIcon(Icons.message),
          matching: find.byType(FloatingActionButton),
        ),
      );
      await tester.pumpAndSettle();

      // Assert child dialog shown
      expect(findDialog('Cubit dialog'), findsOneWidget);
      expect(findDialog('Hello from Second Child'), findsOneWidget);

      // Act - Close child dialog
      await tester.tap(find.text('OK'));

      await tester.pumpAndSettle();

      // Assert child dialog closed
      expect(findDialog('Cubit dialog'), findsNothing);
      expect(findDialog('Hello from Second Child'), findsNothing);
    });
  });
}
