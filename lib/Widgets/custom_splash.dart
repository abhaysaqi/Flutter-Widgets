import 'package:flutter/material.dart';

typedef SplashAnimationBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Widget child,
    );

class ReusableSplashView extends StatefulWidget {
  final String? iconPath;
  final IconData? iconData;
  final double iconSize;
  final Color? iconColor;

  final String? title;
  final TextStyle? titleStyle;

  final Color backgroundColor;
  final Duration animationDuration;
  final VoidCallback onInitializationComplete;

  /// Custom animation builder. If null, the default Fade + Scale animation is used.
  final SplashAnimationBuilder? animationBuilder;

  const ReusableSplashView({
    super.key,
    this.iconPath,
    this.iconData,
    this.iconSize = 100.0,
    this.iconColor,
    this.title,
    this.titleStyle,
    this.backgroundColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 1500),
    required this.onInitializationComplete,
    this.animationBuilder,
  }) : assert(
         (iconPath != null && iconData == null) ||
             (iconPath == null && iconData != null),
         'You must provide either an iconPath or iconData, but not both.',
       );

  @override
  State<ReusableSplashView> createState() => _ReusableSplashViewState();
}

class _ReusableSplashViewState extends State<ReusableSplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _defaultFadeAnimation;
  late Animation<double> _defaultScaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Default animations setup (only utilized if widget.animationBuilder is null)
    _defaultFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _defaultScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Kick off animation and trigger navigation callback when complete
    _animationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          widget.onInitializationComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Build the core static content (Icon/Image + Title)
    final Widget splashContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.iconPath != null)
          Image.asset(
            widget.iconPath!,
            width: widget.iconSize,
            height: widget.iconSize,
          )
        else if (widget.iconData != null)
          Icon(
            widget.iconData,
            size: widget.iconSize,
            color: widget.iconColor ?? Theme.of(context).primaryColor,
          ),
        if (widget.title != null) ...[
          const SizedBox(height: 24),
          Text(
            widget.title!,
            style:
                widget.titleStyle ??
                const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
        ],
      ],
    );

    // 2. Wrap content with either the custom animation or the default animation
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Center(
        child: widget.animationBuilder != null
            ? widget.animationBuilder!(
                context,
                _animationController,
                splashContent,
              )
            : FadeTransition(
                opacity: _defaultFadeAnimation,
                child: ScaleTransition(
                  scale: _defaultScaleAnimation,
                  child: splashContent,
                ),
              ),
      ),
    );
  }
}
