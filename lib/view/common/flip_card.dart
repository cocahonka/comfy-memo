import 'dart:math' as math;

import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  const FlipCard({
    required this.front,
    required this.back,
    required this.duration,
    required this.curve,
    this.onTapCallback,
    this.isDiscrete = true,
    super.key,
  });

  final Widget front;
  final Widget back;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onTapCallback;
  final bool isDiscrete;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _inProgress = false;
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          if (widget.isDiscrete && _inProgress) return;

          _inProgress = true;
          widget.onTapCallback?.call();

          setState(() {
            _isFlipped = !_isFlipped;
          });
        },
        child: Stack(
          children: [
            TweenAnimationBuilder(
              curve: widget.curve,
              tween: Tween<double>(begin: 0, end: _isFlipped ? -180 : 0),
              duration: widget.duration,
              child: widget.back,
              onEnd: () => _inProgress = false,
              builder: (context, value, child) {
                return RotationY(
                  angle: value + 180,
                  child: Offstage(offstage: value >= -90, child: child!),
                );
              },
            ),
            TweenAnimationBuilder(
              curve: widget.curve,
              onEnd: () => _inProgress = false,
              tween: Tween<double>(begin: 0, end: _isFlipped ? -180 : 0),
              duration: widget.duration,
              child: widget.front,
              builder: (context, value, child) {
                return RotationY(
                  angle: value,
                  child: Offstage(offstage: value < -90, child: child!),
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
    required this.child,
    required this.angle,
    super.key,
  });

  final Widget child;
  final double angle;

  static const _degrees2Radians = math.pi / 180.0;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(angle * _degrees2Radians),
      child: child,
    );
  }
}
