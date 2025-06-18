import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final Color activeColor;
  final Color inactiveColor;
  final Color checkColor;

  const StepProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.activeColor = const Color(0xFF2F6F73),
    this.inactiveColor = const Color(0xFFD0DDDE),
    this.checkColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          bool isCompleted = stepIndex < currentStep;
          bool isActive = stepIndex == currentStep;

          return Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted || isActive ? activeColor : inactiveColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isCompleted || isActive ? activeColor : inactiveColor,
                  shape: BoxShape.circle,
                ),
                child: isCompleted
                    ? Icon(Icons.check, size: 14, color: checkColor)
                    : null,
              ),
            ),
          );
        } else {
          return Expanded(
            child: Container(
              height: 2,
              color: (index ~/ 2) < currentStep ? activeColor : inactiveColor,
            ),
          );
        }
      }),
    );
  }
}
