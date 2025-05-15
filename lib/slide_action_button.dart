import 'package:flutter/material.dart';

class SlidingButton extends StatefulWidget {
  final double height;
  final double width;
  final Color backgroundColor;
  final Color sliderColor;
  final Color textColor;
  final String text;
  final double borderRadius;
  final VoidCallback onSlideComplete;
  final Duration animationDuration;
  final bool autoReset;

  const SlidingButton({
    Key? key,
    required this.onSlideComplete,
    this.height = 60,
    this.width = 300,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.sliderColor = Colors.blue,
    this.textColor = Colors.black,
    this.text = "Slide to Confirm",
    this.borderRadius = 30,
    this.animationDuration = const Duration(milliseconds: 300),
    this.autoReset = false,
  }) : super(key: key);

  @override
  State<SlidingButton> createState() => SlidingButtonState();
}

class SlidingButtonState extends State<SlidingButton>
    with SingleTickerProviderStateMixin {
  late double _dragPosition;
  late AnimationController _animationController;
  Animation<double>? _animation;
  bool _isCompleted = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _dragPosition = 0;
    _animationController = AnimationController(vsync: this);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_isCompleted || _isAnimating) return;

    setState(() {
      _dragPosition += details.delta.dx;
      _dragPosition = _dragPosition.clamp(0.0, widget.width - widget.height);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_isCompleted || _isAnimating) return;

    final double maxPosition = widget.width - widget.height;
    final double threshold = maxPosition * 0.85;

    if (_dragPosition >= threshold) {
      _animateToEnd();
    } else {
      _animateToStart();
    }
  }

  void _animateToEnd() {
    final double maxPosition = widget.width - widget.height;
    _isAnimating = true;

    _animation = Tween<double>(begin: _dragPosition, end: maxPosition)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.duration = widget.animationDuration;
    _animationController.reset();

    _animationController.addListener(_updateDragPosition);
    _animationController.addStatusListener(_onEndAnimationStatus);
    _animationController.forward();
  }

  void _onEndAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_isCompleted) {
      _isCompleted = true;
      _isAnimating = false;
      _animationController.removeListener(_updateDragPosition);
      _animationController.removeStatusListener(_onEndAnimationStatus);
      widget.onSlideComplete();

      if (widget.autoReset) {
        Future.delayed(const Duration(milliseconds: 4500), reset);
      }
    }
  }

  void _updateDragPosition() {
    setState(() {
      _dragPosition = _animation?.value ?? 0.0;
    });
  }

  void _animateToStart() {
    _isAnimating = true;
    _animation = Tween<double>(begin: _dragPosition, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.duration = widget.animationDuration;
    _animationController.reset();

    _animationController.addListener(_updateDragPosition);
    _animationController.addStatusListener(_onStartAnimationStatus);
    _animationController.forward();
  }

  void _onStartAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _isAnimating = false;
      _animationController.removeListener(_updateDragPosition);
      _animationController.removeStatusListener(_onStartAnimationStatus);
    }
  }

  void reset() {
    if (!mounted) return;

    setState(() {
      _isCompleted = false;
      _isAnimating = false;
      _dragPosition = 0.0;
    });

    _animationController.reset();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxDrag = widget.width - widget.height;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: _dragPosition < maxDrag * 0.7 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: _dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              child: Container(
                height: widget.height,
                width: widget.height,
                decoration: BoxDecoration(
                  color: widget.sliderColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
