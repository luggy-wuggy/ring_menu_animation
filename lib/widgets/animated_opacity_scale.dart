import 'package:flutter/widgets.dart';

class AnimatedOpacityScale extends StatelessWidget {
  const AnimatedOpacityScale({
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    required this.isVisible,
    required this.child,
  });

  final Duration duration;
  final Curve curve;
  final bool isVisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: duration,
      curve: curve,
      opacity: isVisible ? 1 : 0,
      child: AnimatedScale(
        alignment: Alignment.center,
        curve: curve,
        duration: duration,
        scale: isVisible ? 1 : 0.3,
        child: child,
      ),
    );
  }
}
