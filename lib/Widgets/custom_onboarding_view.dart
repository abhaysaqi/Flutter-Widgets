import 'package:flutter/material.dart';

class CustomOnboardingView extends StatefulWidget {
  final List<OnboardingItem> items;
  final VoidCallback onFinish;
  final VoidCallback? onSkip;

  // Customization Flags
  final bool showSkipButton;
  final bool useArrowButtonOnly; // True = Arrow Icon, False = Text Button ("Next"/"Done")

  // Custom Styling
  final Color activeIndicatorColor;
  final Color inactiveIndicatorColor;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final TextStyle? buttonTextStyle;
  final TextStyle? skipTextStyle;

  const CustomOnboardingView({
    super.key,
    required this.items,
    required this.onFinish,
    this.onSkip,
    this.showSkipButton = true,
    this.useArrowButtonOnly = false,
    this.activeIndicatorColor = Colors.blue,
    this.inactiveIndicatorColor = Colors.grey,
    this.titleStyle,
    this.descriptionStyle,
    this.buttonTextStyle,
    this.skipTextStyle,
  });

  @override
  State<CustomOnboardingView> createState() => _CustomOnboardingViewState();
}

class _CustomOnboardingViewState extends State<CustomOnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  bool get _isLastPage => _currentIndex == widget.items.length - 1;

  void _handleNext() {
    if (_isLastPage) {
      widget.onFinish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleSkip() {
    if (widget.onSkip != null) {
      widget.onSkip!();
    } else {
      _pageController.animateToPage(
        widget.items.length - 1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.items[_currentIndex].backgroundColor ?? Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Core Page Viewer Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.items.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (item.imagePath != null)
                          Image.asset(
                            item.imagePath!,
                            height: 280,
                            fit: BoxFit.contain,
                          )
                        else if (item.iconData != null)
                          Icon(
                            item.iconData,
                            size: 160,
                            color: widget.activeIndicatorColor,
                          ),

                        const SizedBox(height: 40),

                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: widget.titleStyle ??
                              const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: widget.descriptionStyle ??
                              const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Consolidated Bottom Navigation Footer
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Row(
                children: [
                  // 1. SKIP BUTTON (Left Side)
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: widget.showSkipButton && !_isLastPage
                          ? TextButton(
                              onPressed: _handleSkip,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 40),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Skip',
                                style: widget.skipTextStyle ??
                                    const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),

                  // 2. PAGE INDICATORS (Center)
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.items.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 6),
                          height: 8,
                          width: _currentIndex == index ? 20 : 8,
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? widget.activeIndicatorColor
                                : widget.inactiveIndicatorColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 3. NEXT / ARROW BUTTON (Right Side)
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: widget.useArrowButtonOnly
                          ? IconButton.filled(
                              onPressed: _handleNext,
                              icon: Icon(
                                _isLastPage ? Icons.check : Icons.arrow_forward,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: widget.activeIndicatorColor,
                                minimumSize: const Size(50, 50),
                              ),
                            )
                          : TextButton(
                              onPressed: _handleNext,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 40),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                _isLastPage ? 'Done' : 'Next',
                                style: widget.buttonTextStyle ??
                                    TextStyle(
                                      color: widget.activeIndicatorColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String? imagePath;
  final IconData? iconData;
  final String title;
  final String description;
  final Color? backgroundColor;

  const OnboardingItem({
    this.imagePath,
    this.iconData,
    required this.title,
    required this.description,
    this.backgroundColor,
  }) : assert(
          (imagePath != null && iconData == null) ||
              (imagePath == null && iconData != null) ||
              (imagePath == null && iconData == null),
          'Provide either imagePath or iconData, or leave both null.',
        );
}
