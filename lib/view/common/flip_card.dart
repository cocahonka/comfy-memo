import 'dart:math' as math;

import 'package:flutter/material.dart';

enum FlipCardState { front, back }

class FlipCard extends StatefulWidget {
  const FlipCard({
    required this.front,
    required this.back,
    required this.duration,
    required this.curve,
    required this.onFlipped,
    super.key,
  });

  final Widget front;
  final Widget back;
  final Duration duration;
  final Curve curve;
  final ValueChanged<FlipCardState> onFlipped;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  final Tween<double> tween = Tween(begin: 0, end: math.pi);
  late final Animation<double> _animation;
  late final AnimationController _controller;

  double get tweenMiddle => (tween.begin! + tween.end!) / 2;
  bool get isFrontSide => _animation.value <= tweenMiddle;
  bool get isBackSide => !isFrontSide;

  @override
  void initState() {
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ).drive(tween);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_controller.isAnimating) return;

    if (_controller.isCompleted) {
      _controller.reverse();
      widget.onFlipped(FlipCardState.front);
    } else {
      _controller.forward();
      widget.onFlipped(FlipCardState.back);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: _onTap,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animation,
              child: widget.front,
              builder: (context, child) {
                return Offstage(
                  offstage: !isFrontSide,
                  child: RotationY(
                    angle: _animation.value,
                    child: child!,
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _animation,
              child: widget.back,
              builder: (context, child) {
                return Offstage(
                  offstage: !isBackSide,
                  child: RotationY(
                    angle: _animation.value,
                    mirror: true,
                    child: child!,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RotationY extends StatelessWidget {
  const RotationY({
    required this.angle,
    required this.child,
    this.mirror = false,
    super.key,
  });

  final double angle;
  final bool mirror;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(angle + (mirror ? math.pi : 0)),
      child: child,
    );
  }
}
