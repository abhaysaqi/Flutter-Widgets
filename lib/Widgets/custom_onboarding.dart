import 'package:flutter/material.dart';

class CustomOnboarding extends StatelessWidget {
  final PageController controller;
  final int currentIndex;

  final List<OnboardingItem> items;

  final VoidCallback? onSkip;
  final VoidCallback onNext;

  final Widget? nextButton;
  final Widget? skipButton;

  final Color activeDotColor;
  final Color inactiveDotColor;

  const CustomOnboarding({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.items,
    required this.onNext,
    this.onSkip,
    this.nextButton,
    this.skipButton,
    this.activeDotColor = Colors.blue,
    this.inactiveDotColor = Colors.grey,
  });

  bool get isLastPage =>
      currentIndex == items.length - 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Skip Button
        Align(
          alignment: Alignment.topRight,
          child: skipButton ??
              TextButton(
                onPressed: onSkip,
                child: const Text('Skip'),
              ),
        ),

        /// Page View
        Expanded(
          child: PageView.builder(
            controller: controller,
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];

              return Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    item.image,

                    const SizedBox(
                        height: 30),

                    Text(
                      item.title,
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 12),

                    Text(
                      item.description,
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        color:
                            Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        /// Dots
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: List.generate(
            items.length,
            (index) {
              return AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 300,
                ),
                margin:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 4,
                ),
                width:
                    currentIndex ==
                            index
                        ? 22
                        : 8,
                height: 8,
                decoration:
                    BoxDecoration(
                  borderRadius:
                      BorderRadius
                          .circular(20),
                  color:
                      currentIndex ==
                              index
                          ? activeDotColor
                          : inactiveDotColor,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        /// Next Button
        Padding(
          padding:
              const EdgeInsets.all(
                  20),
          child: SizedBox(
            width: double.infinity,
            child: nextButton ??
                ElevatedButton(
                  onPressed: onNext,
                  child: Text(
                    isLastPage
                        ? 'Get Started'
                        : 'Next',
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
