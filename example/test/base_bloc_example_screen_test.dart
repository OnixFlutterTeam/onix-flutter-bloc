import 'package:example/base_bloc_example/base_bloc_example_screen.dart';
import 'package:example/base_bloc_example/bloc/base_bloc_example_screen_bloc.dart';
import 'package:example/base_bloc_example/children/bloc_first_child_screen.dart';
import 'package:example/base_bloc_example/children/bloc_second_child_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onix_flutter_bloc/onix_flutter_bloc.dart';

void main() {
  group('BaseBlocExampleScreen Widget Tests', () {
    Widget createTestWidget() {
      return MaterialApp(
        home: const BaseBlocExampleScreen(
          title: 'Test Screen',
        ),
      );
    }

    Future<BaseBlocExampleScreenBloc?> init(
      WidgetTester tester,
      BaseBlocExampleScreenState emitState,
    ) async {
      await tester.pumpWidget(createTestWidget());

      final bloc =
          (tester.state(find.byType(BaseBlocExampleScreen)) as BaseBlocState)
              .bloc as BaseBlocExampleScreenBloc?;

      bloc?.emit(emitState);

      return bloc;
    }

    testWidgets('should display loading indicator initially', (tester) async {
      // Act
      final bloc = await init(tester, BaseBlocExampleScreenInitial());

      await tester.pump();

      // Assert
      expect(bloc, isNotNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(BlocFirstChildScreen), findsNothing);
      expect(find.byType(BlocSecondChildScreen), findsNothing);
    });

    testWidgets('should display First Child', (tester) async {
      // Act
      final bloc = await init(tester, BaseBlocExampleScreenData());

      await tester.pump();

      // Assert
      expect(bloc, isNotNull);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(BlocFirstChildScreen), findsOneWidget);
      expect(find.byType(BlocSecondChildScreen), findsNothing);

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should display Second Child', (tester) async {
      // Act
      final bloc = await init(tester, BaseBlocExampleScreenData());

      await tester.pump();

      await tester.tap(
        find.ancestor(
          of: find.text('Go to Second Child'), // Find the Text widget first
          matching: find
              .byType(ElevatedButton), // Then find its ElevatedButton ancestor
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(bloc, isNotNull);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(BlocFirstChildScreen), findsNothing);
      expect(find.byType(BlocSecondChildScreen), findsOneWidget);

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should increment counter on button press', (tester) async {
      // Act
      final bloc = await init(tester, BaseBlocExampleScreenData());

      // Assert initial state
      expect(bloc, isNotNull);
      expect(find.text('0'), findsOneWidget);

      // Act - Tap increment button
      await tester.tap(find.byTooltip('Increment'));
      await tester.pumpAndSettle();

      // Assert incremented state
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Should persist counter after child switch', (tester) async {
      // Act
      final bloc = await init(tester, BaseBlocExampleScreenData(counter: 5));

      await tester.pump();

      // Assert initial state
      expect(bloc, isNotNull);
      expect(find.text('5'), findsOneWidget);
      expect(find.byType(BlocFirstChildScreen), findsOneWidget);
      expect(find.byType(BlocSecondChildScreen), findsNothing);

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
      expect(find.byType(BlocFirstChildScreen), findsNothing);
      expect(find.byType(BlocSecondChildScreen), findsOneWidget);
    });

    testWidgets('Should show correct dialogs', (tester) async {
      // Act
      final bloc = await init(tester, BaseBlocExampleScreenData());

      await tester.pump();

      Finder findDialog(String text) => find.descendant(
            of: find.byType(AlertDialog),
            matching: find.text(text),
          );

      // Assert initial state
      expect(bloc, isNotNull);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(BlocFirstChildScreen), findsOneWidget);
      expect(find.byType(BlocSecondChildScreen), findsNothing);

      // Act - Tap show dialog button
      await tester.tap(
        find.ancestor(
          of: find.byIcon(Icons.message),
          matching: find.byType(FloatingActionButton),
        ),
      );
      await tester.pumpAndSettle();

      // Assert dialog shown
      expect(findDialog('Bloc child dialog'), findsOneWidget);
      expect(findDialog('Hello from First Child'), findsOneWidget);

      // Act - Close dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Assert dialog closed
      expect(findDialog('Bloc child dialog'), findsNothing);
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
      expect(find.byType(BlocFirstChildScreen), findsNothing);
      expect(find.byType(BlocSecondChildScreen), findsOneWidget);

      await tester.tap(
        find.ancestor(
          of: find.byIcon(Icons.message),
          matching: find.byType(FloatingActionButton),
        ),
      );
      await tester.pumpAndSettle();

      // Assert child dialog shown
      expect(findDialog('Bloc dialog'), findsOneWidget);
      expect(findDialog('Hello from Second Child'), findsOneWidget);

      // Act - Close child dialog
      await tester.tap(find.text('OK'));

      await tester.pumpAndSettle();

      // Assert child dialog closed
      expect(findDialog('Bloc dialog'), findsNothing);
      expect(findDialog('Hello from Second Child'), findsNothing);
    });
  });
}
