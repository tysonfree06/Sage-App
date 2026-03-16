import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class CountdownTimerWidget extends StatefulWidget {
  const CountdownTimerWidget({required this.targetDate, super.key});
  final DateTime targetDate;

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCountdown(),
    );
  }

  // void _updateCountdown() {
  //   final now = DateTime.now();
  //   final diff = widget.targetDate.difference(now);

  //   setState(() {
  //     _remaining = diff.isNegative ? Duration.zero : diff;
  //   });
  // }

  void _updateCountdown() {
    final now = DateTime.now();
    final targetMonth = widget.targetDate.month;
    final targetDay = widget.targetDate.day;

    // Create anniversary date for this year
    DateTime nextAnniversary = DateTime(now.year, targetMonth, targetDay);

    // If the anniversary already passed this year, move to next year
    if (nextAnniversary.isBefore(now)) {
      nextAnniversary = DateTime(now.year + 1, targetMonth, targetDay);
    }

    final diff = nextAnniversary.difference(now);

    setState(() {
      _remaining = diff;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Map<String, String> _getTimeParts() {
    var totalSeconds = _remaining.inSeconds;

    final days = totalSeconds ~/ (24 * 3600);
    totalSeconds %= 24 * 3600;
    final hours = totalSeconds ~/ 3600;
    totalSeconds %= 3600;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return {
      'Days': days.toString().padLeft(2, '0'),
      'Hrs': hours.toString().padLeft(2, '0'),
      'Mins': minutes.toString().padLeft(2, '0'),
      'Sec': seconds.toString().padLeft(2, '0'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final timeParts = _getTimeParts();
    final keys = timeParts.keys.toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(keys.length, (index) {
        final label = keys[index];
        final value = timeParts[label]!;

        return Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.colors.mainGreenDark,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    value,
                    style: context.typography.label.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                      color: context.colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  label,
                  style: context.typography.label.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: context.colors.mainGreenDark,
                  ),
                ),
              ],
            ),
            if (index < keys.length - 1)
              Padding(
                padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 24.h),
                child: Text(
                  ':',
                  style: context.typography.label.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                    color: context.colors.mainGreenDark,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
