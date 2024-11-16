import 'package:flutter/material.dart';
import 'package:gafa_indicator/gafa_indicator.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gafa Indicator Examples'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BasicExamplePage()),
                );
              },
              child: Text('View Basic Example'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnimationExamplePage()),
                );
              },
              child: Text('View Animation Example'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TypeExamplePage()),
                );
              },
              child: Text('Type Example'),
            ),
          ],
        ),
      ),
    );
  }
}

class BasicExamplePage extends StatelessWidget {
  final List<IndicatorType> indicatorTypes = [
    IndicatorType.unfilledStatic,
    IndicatorType.fixedUnfilledEnd,
    IndicatorType.movingUnfilled,
    IndicatorType.reverseUnfilledShift,
  ];

  List<Color> _generateRandomColors() {
    final random = Random();
    return [
      Color.fromARGB(
          255, random.nextInt(256), random.nextInt(256), random.nextInt(256)),
      Color.fromARGB(
          255, random.nextInt(256), random.nextInt(256), random.nextInt(256)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Example'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 24,
        itemBuilder: (context, index) {
          return GradientAniFlowArcIndicator(
            innerRadius: 20,
            outerRadius: 25,
            percentage: Random().nextDouble() * 100,
            colors: _generateRandomColors(),
            unfilledColor: Colors.black,
            centerText: null,
            innerCircleColor: Colors.white,
            enableAnimation: true,
            type: indicatorTypes[index % indicatorTypes.length],
          );
        },
      ),
    );
  }
}

class AnimationExamplePage extends StatefulWidget {
  @override
  _AnimationExamplePageState createState() => _AnimationExamplePageState();
}

class _AnimationExamplePageState extends State<AnimationExamplePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final double percentage = 75;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_animation.value);
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation Example'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return GradientAniFlowArcIndicator(
              innerRadius: 60,
              outerRadius: 70,
              // please input constant value
              percentage: percentage,
              colors: [Colors.purple, Colors.blue],
              unfilledColor: Colors.redAccent,
              centerText: Text(
                // To animate the text value, ensure you use animation.value as input.
                // Use toStringAsFixed(n) to format the value for a cleaner display.
                '${_animation.value.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              innerCircleColor: Colors.amber,
              flowAnimation: (_animation, _controller),
              enableAnimation: true,
              type: IndicatorType.unfilledStatic,
            );
          },
        ),
      ),
    );
  }
}

class TypeExamplePage extends StatelessWidget {
  final List<IndicatorType> indicatorTypes = [
    IndicatorType.unfilledStatic,
    IndicatorType.fixedUnfilledEnd,
    IndicatorType.movingUnfilled,
    IndicatorType.reverseUnfilledShift,
  ];

  List<Color> _generateRandomColors() {
    final random = Random();
    return [
      Color.fromARGB(
          255, random.nextInt(256), random.nextInt(256), random.nextInt(256)),
      Color.fromARGB(
          255, random.nextInt(256), random.nextInt(256), random.nextInt(256)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Example'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: GradientAniFlowArcIndicator(
          innerRadius: 60,
          outerRadius: 70,
          percentage: 77.7,
          colors: [Colors.lime.shade100, Colors.lightGreen],
          unfilledColor: Colors.black,
          centerText: null,
          innerCircleColor: Colors.white,
          enableAnimation: true,
          type: IndicatorType.fixedUnfilledEnd,
        ),
      ),
    );
  }
}
