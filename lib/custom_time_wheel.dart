import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/appearance/gradient_colors.dart';
import 'gong_feature/gongs.dart';
import 'background_sounds_feature/sounds.dart';

enum WheelMode { numbers, colors, gongs, sounds }

class CustomTimeWheel extends StatefulWidget {
  final int itemCount;
  final double itemExtent;
  final Function(int) onSelectedItemChanged;
  final int selectedValue;
  final double diameterRatio;
  final double perspective;
  final ScrollController? scrollController;
  final int? autoScrollToItem;
  final WheelMode mode;
  final List<String>? colorNames;

  const CustomTimeWheel({
    super.key,
    required this.itemCount,
    required this.onSelectedItemChanged,
    required this.selectedValue,
    this.itemExtent = 65,
    this.diameterRatio = 1.5,
    this.perspective = 0.009,
    this.scrollController,
    this.autoScrollToItem,
    this.mode = WheelMode.numbers,
    this.colorNames,
  });

  @override
  _CustomTimeWheelState createState() => _CustomTimeWheelState();
}

class _CustomTimeWheelState extends State<CustomTimeWheel> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ??
        FixedExtentScrollController(initialItem: widget.selectedValue);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && widget.autoScrollToItem != null) {
        final fixedExtentScrollController =
            _scrollController as FixedExtentScrollController;

        fixedExtentScrollController.animateToItem(
          widget.autoScrollToItem!,
          duration: const Duration(seconds: 1, milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListWheelScrollView.useDelegate(
        controller: _scrollController,
        itemExtent: widget.itemExtent,
        diameterRatio: widget.diameterRatio,
        perspective: widget.perspective,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: widget.onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: widget.itemCount,
          builder: (BuildContext context, int index) {
            final bool isSelected = index == widget.selectedValue;
            final double opacity = isSelected
                ? 1.0
                : (1 / (1 + (index - widget.selectedValue).abs() * 0.5))
                    .clamp(0.1, 1.0);

            Widget content;
            switch (widget.mode) {
              case WheelMode.numbers:
                content = Text(
                  index.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: isSelected ? 53 : 50,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(opacity),
                    fontWeight: FontWeight.bold,
                  ),
                );
                break;
              case WheelMode.colors:
                content = Text(
                  GradientColors.names[index],
                  style: TextStyle(
                    fontSize: isSelected ? 24 : 20,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(opacity),
                    fontWeight: FontWeight.bold,
                  ),
                );
                break;
              case WheelMode.gongs:
                content = Text(
                  GongSounds.names[index],
                  style: TextStyle(
                    fontSize: isSelected ? 24 : 20,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(opacity),
                    fontWeight: FontWeight.bold,
                  ),
                );
                break;
              case WheelMode.sounds:
                content = Text(
                  BackgroundsSounds.names[index],
                  style: TextStyle(
                    fontSize: isSelected ? 24 : 20,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(opacity),
                    fontWeight: FontWeight.bold,
                  ),
                );
                break;
            }

            return Container(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacity,
                child: content,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }
}
