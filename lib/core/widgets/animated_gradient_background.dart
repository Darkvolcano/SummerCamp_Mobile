import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final List<Color> gradientColors;
  final List<Color> blobColors;

  const AnimatedGradientBackground({
    super.key,
    required this.gradientColors,
    required this.blobColors,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> {
  Timer? _timer;
  final Random _random = Random();

  // State for blob positions and sizes
  late double _blob1Top, _blob1Left, _blob1Size;
  late double _blob2Top, _blob2Left, _blob2Size;
  late double _blob3Top, _blob3Left, _blob3Size;

  @override
  void initState() {
    super.initState();
    _initializeBlobs();
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      _updateBlobPositions();
    });
  }

  void _initializeBlobs() {
    final screenWidth =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .physicalSize
            .width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final screenHeight =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .physicalSize
            .height /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    _blob1Size = _random.nextDouble() * 200 + 300;
    _blob1Top = _random.nextDouble() * screenHeight - (_blob1Size / 2);
    _blob1Left = _random.nextDouble() * screenWidth - (_blob1Size / 2);

    _blob2Size = _random.nextDouble() * 150 + 250;
    _blob2Top = _random.nextDouble() * screenHeight - (_blob2Size / 2);
    _blob2Left = _random.nextDouble() * screenWidth - (_blob2Size / 2);

    _blob3Size = _random.nextDouble() * 100 + 400;
    _blob3Top = _random.nextDouble() * screenHeight - (_blob3Size / 2);
    _blob3Left = _random.nextDouble() * screenWidth - (_blob3Size / 2);
  }

  void _updateBlobPositions() {
    if (!mounted) return;
    final size = MediaQuery.of(context).size;
    setState(() {
      _blob1Top = _random.nextDouble() * size.height - (_blob1Size / 2);
      _blob1Left = _random.nextDouble() * size.width - (_blob1Size / 2);

      _blob2Top = _random.nextDouble() * size.height - (_blob2Size / 2);
      _blob2Left = _random.nextDouble() * size.width - (_blob2Size / 2);

      _blob3Top = _random.nextDouble() * size.height - (_blob3Size / 2);
      _blob3Left = _random.nextDouble() * size.width - (_blob3Size / 2);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Gradient Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Floating Blobs
        _buildAnimatedBlob(
          _blob1Top,
          _blob1Left,
          _blob1Size,
          widget.blobColors[0],
        ),
        _buildAnimatedBlob(
          _blob2Top,
          _blob2Left,
          _blob2Size,
          widget.blobColors[1],
        ),
        _buildAnimatedBlob(
          _blob3Top,
          _blob3Left,
          _blob3Size,
          widget.blobColors[2],
        ),
      ],
    );
  }

  Widget _buildAnimatedBlob(double top, double left, double size, Color color) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 7),
      curve: Curves.easeInOut,
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
