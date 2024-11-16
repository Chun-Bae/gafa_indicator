# Gafa Indicator

A Flutter widget for creating customizable gradient flow arc indicators with animations. Perfect for visually representing progress, percentages, or dynamic states in your app.

## Features

- Gradient flow arc with customizable colors.
- Multiple indicator types:
  - UnfilledStatic: Fills unfilled color up to the current percentage.
  - FixedUnfilledEnd: Unfilled color remains static up to max percentage.
  - MovingUnfilled: Unfilled color moves with the progress.
  - ReverseUnfilledShift: Unfilled color shifts in reverse with progress.
- Animation support with smooth transitions.
- Customizable animations via the `flowAnimation` property.
- Easily adjustable radius, colors, and percentages.

## Getting started

To get started, ensure that you have Flutter installed on your machine. Add the following dependency in your `pubspec.yaml`:

```yaml
dependencies:
  gafa_indicator: ^0.0.1
```

Run `flutter pub get` to fetch the package.

## Usage

Here's a simple example of how to use `GafaIndicator` in your Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:gafa_indicator/gafa_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Gafa Indicator Example')),
        body: Center(
          child: GradientAniFlowArcIndicator(
            innerRadius: 20,
            outerRadius: 30,
            percentage: 70,
            colors: [Colors.blue, Colors.purple],
            unfilledColor: Colors.grey,
            type: IndicatorType.unfilledStatic,
          ),
        ),
      ),
    );
  }
}
```

For more examples, check the `example` folder in this repository.

## Indicator Types

- **UnfilledStatic**:
  - The unfilled color fills up to the current progress percentage.
- **FixedUnfilledEnd**:
  - The unfilled color remains fixed up to the maximum percentage.
- **MovingUnfilled**:
  - The unfilled color moves along with the progress.
- **ReverseUnfilledShift**:
  - The unfilled color shifts in reverse with the progress percentage.

## Animation Customization

- You can customize animations for the arc using the `flowAnimation` property, which accepts a record of `Animation<double>` and `AnimationController`.
- Avoid directly assigning `animation.value` to the `percentage` property to prevent rendering issues.
- If you want to animate the text, you **must** provide `animation.value` as the input for the text property.

### Example with Custom Animation

```dart
GradientAniFlowArcIndicator(
  innerRadius: 20,
  outerRadius: 30,
  percentage: 70, // Avoid setting animation.value here.
  flowAnimation: (
    Tween<double>(begin: 0, end: 100).animate(animationController),
    animationController
  ),
  centerText: Text(
  // To animate the text value, ensure you use animation.value as input.
  // Use toStringAsFixed(n) to format the value for a cleaner display.
  // Do not set animation.value directly to the `percentage` property of the widget.
  // If you want the text to animate, pass animation.value here explicitly.
  '${_animation.value.toStringAsFixed(1)}%',
  style: TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 116, 221, 68),
    ),
  ),
  colors: [Colors.blue, Colors.green],
  type: IndicatorType.movingUnfilled,
);
```

## Additional information

For bug reports, feature requests, or contributions, feel free to open an issue or submit a pull request on [GitHub](https://github.com/Chun-Bae/gafa_indicator.git).
