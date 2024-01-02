import 'package:flutter/material.dart';
import 'package:ring_animation_menu/widgets/animated_opacity_scale.dart';
import 'package:ring_animation_menu/widgets/draggable_ring.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          PeerRingMenu(),
          DraggableRing(
            onTap: () {
              print("hey");
            },
            screenSize: MediaQuery.of(context).size,
          ),
          const Align(
            alignment: Alignment(0, 0.25),
            child: Text(
              'A ring animation UI',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PeerRingMenu extends StatelessWidget {
  PeerRingMenu({super.key});

  final List<RingAction> ringMenuActions = [
    RingAction(
      icon: Icons.message,
      title: 'messages',
      onSelected: () {
        print("MESSAGES");
      },
      isLocked: false,
    ),
    RingAction(
      icon: Icons.add,
      title: 'create',
      onSelected: () {
        print("CREATE");
      },
      isLocked: false,
    ),
    RingAction(
      icon: Icons.place,
      title: 'discover',
      onSelected: () {
        print("DISCOVER");
      },
      isLocked: false,
    ),
    RingAction(
      icon: Icons.nature_rounded,
      title: 'slingshot',
      onSelected: () {},
      isLocked: true,
    ),
    RingAction(
      icon: Icons.military_tech_rounded,
      title: 'create AR',
      onSelected: () {},
      isLocked: true,
    ),
    RingAction(
      icon: Icons.newspaper,
      title: 'my feed',
      onSelected: () {},
      isLocked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // final ringMenuActions = ref.watch(ringMenuActionsProvider);
    // final selectedRingAction = ref.watch(selectedRingActionProvider);
    String ringActionTitle = '';

    // if (!(selectedRingAction?.isLocked ?? false)) {
    //   ringActionTitle = selectedRingAction?.title ?? '';
    // }

    final size = MediaQuery.of(context).size;

    return Align(
      alignment: const Alignment(0, -0.4),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Transform.translate(
            offset: const Offset(0, -80),
            child: Text(
              ringActionTitle,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Wrap(
              spacing: 15,
              runSpacing: 10,
              children: List.generate(
                ringMenuActions.length,
                (index) {
                  final rowNormalized = index.remainder(3).floor();
                  final isMiddleOption = rowNormalized == 1;
                  var duration = const Duration(milliseconds: 320);

                  if (index >= 3) {
                    duration = const Duration(milliseconds: 180);
                  }

                  return DragTargetMenuItems(
                    isMiddleOption: isMiddleOption,
                    duration: duration,
                    ringAction: ringMenuActions[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DragTargetMenuItems extends StatefulWidget {
  const DragTargetMenuItems({
    Key? key,
    required this.isMiddleOption,
    required this.duration,
    required this.ringAction,
  }) : super(key: key);

  final bool isMiddleOption;
  final Duration duration;
  final RingAction ringAction;

  @override
  State<DragTargetMenuItems> createState() => _DragTargetMenuItemsState();
}

class _DragTargetMenuItemsState extends State<DragTargetMenuItems> {
  @override
  Widget build(BuildContext context) {
    // final isDragging = ref.watch(isRingDraggingProvider);

    return AnimatedOpacityScale(
      isVisible: true, //isDragging,
      duration: widget.duration,
      curve: Curves.easeInOutCubic,
      child: Transform.translate(
        offset: Offset(0, widget.isMiddleOption ? -20 : 0),
        child: DragTarget<String>(
          key: UniqueKey(),
          onAccept: (data) {
            widget.ringAction.onSelected?.call();
          },
          onMove: ((details) {
            // if (ref.read(selectedRingActionProvider.state).state ==
            //     widget.ringAction) {
            //   return;
            // }

            // ref
            //     .read(selectedRingActionProvider.state)
            //     .update((state) => widget.ringAction);
          }),
          onLeave: ((data) {
            // if (ref.read(selectedRingActionProvider.state).state == null) {
            //   return;
            // }

            // ref.read(selectedRingActionProvider.state).update((state) => null);
          }),
          builder: ((context, candidateData, rejectedData) {
            final hasData = candidateData.isNotEmpty;

            return SizedBox(
              height: 80,
              width: 80,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  if (widget.ringAction.isLocked)
                    Transform.scale(
                      scale: 2,
                      child: const SizedBox(
                        height: 80,
                        width: 80,
                        child: AnimatedOpacity(
                          opacity: 1, // widget.ringAction.isLocked && hasData ? 1 : 0,
                          duration: Duration(milliseconds: 140),
                          curve: Curves.easeInOut,
                          // child: Lottie.asset(
                          //   'assets/lottie/stars_loop.json',
                          //   animate: widget.ringAction.isLocked && hasData,
                          // ),
                        ),
                      ),
                    ),
                  if (!widget.ringAction.isLocked)
                    AnimatedOpacityScale(
                      isVisible: true, //!widget.ringAction.isLocked && hasData,
                      duration: const Duration(milliseconds: 80),
                      curve: Curves.easeInOut,
                      child: Container(),
                      // child: Pulser(
                      //   colors: [colors.marbleMagenta, colors.marbleTeal],
                      //   size: const Size(32, 32),
                      //   duration: const Duration(milliseconds: 750),
                      //   waves: 3,
                      //   distanceBetweenWaves: 9,
                      //   useRect: true,
                      //   roundedRadius: 36,
                      //   maxOpacity: 0.25,
                      // ),
                    ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: widget.ringAction.isLocked && hasData ? 54.5 : 56,
                    width: widget.ringAction.isLocked && hasData ? 54.5 : 56,
                    decoration: BoxDecoration(
                      color: Colors.grey, //widget.ringAction.isLocked ? Colors.grey : Colors.black,
                      gradient: (hasData && !widget.ringAction.isLocked)
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment(1.0, 1.8),
                              colors: [
                                Color(0xFFFE00EE),
                                Color(0XFF12FFFC),
                              ],
                            )
                          : null,
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                    ),
                    child: widget.ringAction.isLocked
                        ? const Icon(
                            Icons.lock,
                            size: 32,
                          )
                        : Icon(
                            widget.ringAction.icon,
                            size: 32,
                          ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class RingAction {
  final IconData icon;
  final VoidCallback? onSelected;
  final bool isLocked;
  final String title;

  RingAction({
    required this.icon,
    required this.title,
    this.onSelected,
    this.isLocked = false,
  });
}
