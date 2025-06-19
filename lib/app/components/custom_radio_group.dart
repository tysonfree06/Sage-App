import 'package:flutter/material.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class CustomRadioGroup<T> extends StatelessWidget {

  const CustomRadioGroup({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.labelBuilder,
    this.direction = Axis.horizontal,
  });

  final List<T> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      children: options.map((option) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<T>(
              value: option,
              groupValue: selectedValue,
              onChanged: (value) {
                if (value != null) onChanged(value);
              },
            ),
            Text(labelBuilder(option), style: context.typography.subtitle.copyWith(),),
          ],
        );
      }).toList(),
    );
  }
}
