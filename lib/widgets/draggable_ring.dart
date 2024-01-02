import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

class DraggableRing extends StatefulWidget {
  const DraggableRing({
    Key? key,
    required this.onTap,
    required this.screenSize,
  }) : super(key: key);

  final Function onTap;
  final Size screenSize;

  @override
  DraggableRingState createState() => DraggableRingState();
}

class DraggableRingState extends State<DraggableRing> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Offset> _animation;
  late Offset initialOffset;
  late Offset _ringOffset;
  final double ringSize = 71;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    initialOffset = Offset(
      (widget.screenSize.width / 2) - (ringSize / 2),
      (widget.screenSize.height / 2 - (ringSize / 2)),
    );

    _ringOffset = initialOffset;

    _controller = AnimationController(
      vsync: this,
    )..addListener(() {
        setState(() {
          _ringOffset = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(Tween<Offset>(begin: _ringOffset, end: initialOffset));

    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 160),
            opacity: isDragging ? 1 : 0,
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 220),
              height: isDragging ? 9 : 40,
              width: isDragging ? 9 : 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          top: _ringOffset.dy,
          left: _ringOffset.dx,
          child: Draggable(
            data: 'ring',
            onDragStarted: () {
              setState(() {
                isDragging = true;
              });
            },
            onDragEnd: (details) {
              setState(() {
                isDragging = false;
              });

              _runAnimation(details.velocity.pixelsPerSecond, size);
            },
            onDragUpdate: (details) {
              setState(() {
                _ringOffset = Offset((details.globalPosition.dx - (ringSize / 2)),
                    (details.globalPosition.dy - (ringSize / 2)));
              });
            },
            feedback: SizedBox(height: ringSize, width: ringSize),
            child: IgnorePointer(
              ignoring: isDragging,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.center,
                height: isDragging ? 56 : ringSize,
                width: isDragging ? 56 : ringSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 8,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
