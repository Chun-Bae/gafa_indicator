import 'package:flutter_test/flutter_test.dart';
import 'package:gafa_indicator/gafa_indicator.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('GafaIndicator renders correctly with default settings', (WidgetTester tester) async {
    // Arrange: Create a widget to test
    final widget = MaterialApp(
      home: Scaffold(
        body: GradientAniFlowArcIndicator(
          innerRadius: 20,
          outerRadius: 30,
          percentage: 70,
          colors: [Colors.blue, Colors.purple],
          unfilledColor: Colors.grey,
          type: IndicatorType.unfilledStatic,
        ),
      ),
    );

    // Act: Pump the widget into the widget tree
    await tester.pumpWidget(widget);

    // Assert: Verify that the widget tree contains the expected elements
    expect(find.byType(GradientAniFlowArcIndicator), findsOneWidget);
    expect(find.textContaining('%'), findsNothing); // Check for text display.
  });
}
