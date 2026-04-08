import 'package:flutter_test/flutter_test.dart';
import 'package:rehab/src/app.dart';

void main() {
  testWidgets('Splash transitions and all tabs render', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RehabApp());

    expect(find.text('Rehab Sanctuary'), findsOneWidget);
    expect(find.text('CLINICAL EXCELLENCE'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.text('Knee Overview'), findsOneWidget);
    expect(
      find.text('Firestore-backed knee rehab status for the current patient.'),
      findsOneWidget,
    );
    expect(find.text('Guided Knee Exercises'), findsOneWidget);

    await tester.tap(find.text('ELBOW').last);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Elbow Overview'), findsOneWidget);
    expect(
      find.text('Firestore-backed elbow rehab status for the current patient.'),
      findsOneWidget,
    );
    expect(find.text('Guided Elbow Exercises'), findsOneWidget);

    await tester.tap(find.text('CONFIG').last);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Config'), findsWidgets);
    expect(find.text('Connected Devices'), findsOneWidget);
    expect(find.text('Connectivity Preferences'), findsOneWidget);
    expect(find.text('Pair New Device'), findsOneWidget);
  });
}
