import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../common/common.dart';
import '../widgets/widgets.dart';

double randomValue = 2;

class FortuneWheelPage extends HookWidget {
  static const kRouteName = 'FortuneWheelPage';

  static void go(BuildContext context) {
    context.goNamed(kRouteName);
  }

  @override
  Widget build(BuildContext context) {
    final alignment = useState(Alignment.topCenter);
    final selected = useStreamController<int>();
    final selectedIndex = useStream(selected.stream, initialData: 0).data ?? 0;
    final isAnimating = useState(false);

    final alignmentSelector = AlignmentSelector(
      selected: alignment.value,
      onChanged: (v) => alignment.value = v!,
    );

    void handleRoll() {
      randomValue = generateRandomValue();
      print("randomValue $randomValue");
      selected.add(
        roll(Constants.fortuneValues.length),
      );
    }

    return AppLayout(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            alignmentSelector,
            SizedBox(height: 8),
            RollButtonWithPreview(
              selected: selectedIndex,
              items: Constants.fortuneValues,
              onPressed: isAnimating.value ? null : handleRoll,
            ),
            SizedBox(height: 8),
            Expanded(
              child: FortuneWheel(
                randomOffset: randomValue,
                alignment: alignment.value,
                selected: selected.stream,
                onAnimationStart: () => isAnimating.value = true,
                onAnimationEnd: () => isAnimating.value = false,
                onFling: handleRoll,
                duration: Duration(seconds: 5),
                hapticImpact: HapticImpact.heavy,
                indicators: [
                  FortuneIndicator(
                    alignment: alignment.value,
                    child: TriangleIndicator(),
                  ),
                ],
                items: [for (var it in Constants.fortuneValues) FortuneItem(child: Text(it), onTap: () => print(it))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double generateRandomValue() {
  final random = Random();
  const values = [1.7, 2.5];
  return values[random.nextInt(values.length)];
}
