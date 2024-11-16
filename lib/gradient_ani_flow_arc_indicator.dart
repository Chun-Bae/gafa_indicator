import 'package:flutter/material.dart';
import 'dart:math';
import 'gafa_painter.dart';

enum IndicatorType {
  unfilledStatic,
  fixedUnfilledEnd,
  movingUnfilled,
  reverseUnfilledShift,
}

class GradientAniFlowArcIndicator extends StatefulWidget {
  final double innerRadius; // 안쪽 원 반지름
  final double outerRadius; // 바깥쪽 원 반지름
  final double percentage; // 퍼센트 (0 ~ 100)
  final Text? centerText; // 가운데 텍스트
  final List<Color> colors; // 그라디언트 색상 리스트
  final Color innerCircleColor; // 안쪽 원 색상
  final Color unfilledColor; // 채워지지 않은 부분 색상
  final (Animation<double>, AnimationController)? flowAnimation;
  final bool enableAnimation; // 애니메이션 활성화 여부
  final IndicatorType type; // 인디케이터 타입

  const GradientAniFlowArcIndicator({
    required this.innerRadius,
    required this.outerRadius,
    required this.percentage,
    required this.colors,
    this.centerText,
    this.innerCircleColor = Colors.white,
    this.unfilledColor = Colors.black,
    this.flowAnimation,
    this.enableAnimation = true,
    this.type = IndicatorType.unfilledStatic,
  }) : assert(colors.length == 2, 'colors 리스트는 반드시 두 개의 색상을 포함해야 합니다.');

  @override
  _GradientAniFlowArcIndicatorState createState() =>
      _GradientAniFlowArcIndicatorState();
}

class _GradientAniFlowArcIndicatorState
    extends State<GradientAniFlowArcIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _defaultController;
  late Animation<double> _animation;
  late double _percentage;
  double _currentPercentage = 0;

  @override
  void initState() {
    super.initState();
    _percentage = widget.percentage;

    if (widget.enableAnimation) {
      if (widget.flowAnimation != null) {
        _defaultController = widget.flowAnimation!.$2;
        _animation = widget.flowAnimation!.$1;
        _defaultController.forward();
      } else {
        _defaultController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 800),
        );

        _animation = Tween<double>(
          begin: 0,
          end: widget.percentage,
        ).animate(
          CurvedAnimation(
              parent: _defaultController, curve: Curves.easeInOutQuart),
        );

        _defaultController.forward();
      }
    } else {
      _currentPercentage = widget.percentage;
    }
  }

  @override
  void didUpdateWidget(covariant GradientAniFlowArcIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enableAnimation &&
        widget.flowAnimation == null &&
        oldWidget.percentage != widget.percentage) {
      _defaultController.forward(from: 0);
    } else if (!widget.enableAnimation) {
      setState(() => _currentPercentage = widget.percentage);
    }
  }

  @override
  void dispose() {
    if (widget.enableAnimation && widget.flowAnimation == null) {
      _defaultController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableAnimation) {
      return _buildGafa(_currentPercentage, _percentage);
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _buildGafa(_animation.value, _percentage);
      },
    );
  }

  Widget _buildGafa(double percentage, double maxPercentage) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: widget.colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: CustomPaint(
            size: Size(widget.outerRadius * 2, widget.outerRadius * 2),
            painter: GafaPainter(
              startAngle: -pi / 2,
              sweepAngle:
                  percentage == 100 ? 2 * pi : (2 * pi) * (percentage / 100),
              innerRadius: percentage == 100 ? 0 : widget.innerRadius,
              outerRadius: widget.outerRadius,
              color: widget.unfilledColor,
            ),
          ),
        ),
        ..._buildProgressIndicator(
          percentage: percentage,
          maxPercentage: maxPercentage,
          type: widget.type,
        ),
        CircleWidget(
          size: widget.innerRadius * 2,
          color: widget.innerCircleColor,
        ),
        (widget.centerText != null)
            ? (widget.centerText!)
            : Text(
                '${(percentage % 1 == 0 ? percentage.toInt() : percentage.toStringAsFixed(1))}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.outerRadius / 2,
                ),
              ),
      ],
    );
  }

  List<Widget> _buildProgressIndicator({
    required double percentage,
    required double maxPercentage,
    required IndicatorType type,
  }) {
    switch (type) {
      case IndicatorType.unfilledStatic:
        return [
          // 1: Unfilled color fills up to the current percentage
          _progressUnfilledStatic1(
              percentage: percentage, maxPercentage: maxPercentage),
          _progressUnfilledStatic2(
              percentage: percentage, maxPercentage: maxPercentage)
        ];
      case IndicatorType.fixedUnfilledEnd:
        return [
          // 2: Unfilled color fills up to the maxPercentage and remains static
          _progressFixedUnfilledEnd(
              percentage: percentage, maxPercentage: maxPercentage)
        ];
      // 3: Unfilled color stays fixed and progresses alongside the current percentage
      case IndicatorType.movingUnfilled:
        return [
          _progressMovingUnfilled(
              percentage: percentage, maxPercentage: maxPercentage)
        ];
      // 4: Unfilled color moves in reverse alongside the current percentage
      case IndicatorType.reverseUnfilledShift:
        return [
          _ProgressReverseUnfilledShift(
              percentage: percentage, maxPercentage: maxPercentage)
        ];
    }
  }

  Widget _progressUnfilledStatic1(
      {required double percentage, required double maxPercentage}) {
    return CustomPaint(
      size: Size(widget.outerRadius * 2, widget.outerRadius * 2),
      painter: GafaPainter(
        startAngle: -pi / 2 + (2 * pi) * (maxPercentage / 100),
        sweepAngle: (2 * pi) * ((percentage - maxPercentage) / 100),
        innerRadius: percentage == 100 ? 0 : widget.innerRadius,
        outerRadius: widget.outerRadius,
        color: widget.unfilledColor,
      ),
    );
  }

  Widget _progressUnfilledStatic2(
      {required double percentage, required double maxPercentage}) {
    return CustomPaint(
      size: Size(widget.outerRadius * 2, widget.outerRadius * 2),
      painter: GafaPainter(
        startAngle: -pi / 2 + (2 * pi) * (maxPercentage / 100),
        sweepAngle: (2 * pi) * (1 - maxPercentage / 100),
        innerRadius: percentage == 100 ? 0 : widget.innerRadius,
        outerRadius: widget.outerRadius,
        color: widget.unfilledColor,
      ),
    );
  }

  Widget _progressFixedUnfilledEnd(
      {required double percentage, required double maxPercentage}) {
    return CustomPaint(
      size: Size(widget.outerRadius * 2, widget.outerRadius * 2),
      painter: GafaPainter(
        startAngle: -pi / 2 + (2 * pi) * (maxPercentage / 100),
        sweepAngle: (2 * pi) * (1 - maxPercentage / 100),
        innerRadius: percentage == 100 ? 0 : widget.innerRadius,
        outerRadius: widget.outerRadius,
        color: widget.unfilledColor,
      ),
    );
  }

  Widget _progressMovingUnfilled(
      {required double percentage, required double maxPercentage}) {
    {
      return CustomPaint(
        size: Size(widget.outerRadius * 2, widget.outerRadius * 2),
        painter: GafaPainter(
          startAngle: -pi / 2 + (2 * pi) * (percentage / 100),
          sweepAngle: (2 * pi) * (1 - maxPercentage / 100),
          innerRadius: percentage == 100 ? 0 : widget.innerRadius,
          outerRadius: widget.outerRadius,
          color: widget.unfilledColor,
        ),
      );
    }
  }

  Widget _ProgressReverseUnfilledShift(
      {required double percentage, required double maxPercentage}) {
    {
      return CustomPaint(
        size: Size(widget.outerRadius * 2, widget.outerRadius * 2),
        painter: GafaPainter(
          startAngle: -pi / 2 +
              (2 * pi) *
                  ((100 -
                          ((100 - maxPercentage) *
                              (percentage) /
                              (maxPercentage))) /
                      100),
          sweepAngle: (2 * pi) *
              (((100 - maxPercentage) * (percentage) / (maxPercentage)) / 100),
          innerRadius: percentage == 100 ? 0 : widget.innerRadius,
          outerRadius: widget.outerRadius,
          color: widget.unfilledColor,
        ),
      );
    }
  }
}
