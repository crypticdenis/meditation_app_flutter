import 'package:flutter/material.dart';
import 'package:meditation_app/gradient_colors.dart';
import 'gongs.dart';

enum WheelMode { numbers, colors, gongs }

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
  final List<String>? colorNames; // This line was missing

  const CustomTimeWheel({
    super.key,
    required this.itemCount,
    required this.onSelectedItemChanged,
    required this.selectedValue,
    this.itemExtent = 35,
    this.diameterRatio = 1,
    this.perspective = 0.009,
    this.scrollController,
    this.autoScrollToItem,
    this.mode = WheelMode.numbers, // Default to numbers mode
    this.colorNames, // Ensure this is added
  });

  @override
  _CustomTimeWheelState createState() => _CustomTimeWheelState();
}

class _CustomTimeWheelState extends State<CustomTimeWheel> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? FixedExtentScrollController(initialItem: widget.selectedValue);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && widget.autoScrollToItem != null) {
        final fixedExtentScrollController = _scrollController as FixedExtentScrollController;

        fixedExtentScrollController.animateToItem(
          widget.autoScrollToItem!, // Use the autoScrollToItem value
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

            // Conditional content based on the mode
            Widget content;
            switch (widget.mode) {
              case WheelMode.numbers:
                content = Text(
                  index.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: isSelected ? 32 : 30,
                    color: isSelected ? Colors.white : Colors.white.withOpacity(opacity),
                    fontWeight: FontWeight.bold,
                  ),
                );
                break;
              case WheelMode.colors:
              // Assuming GradientTheme.names[index] gives the name of the color
                content = Text(
                  GradientColors.names[index],
                  style: TextStyle(
                    fontSize: isSelected ? 24 : 20,
                    color: isSelected ? Colors.white : Colors.white.withOpacity(opacity),
                    fontWeight: FontWeight.bold,
                  ),
                );
                break;
              case WheelMode.gongs:
              // Assuming GradientTheme.names[index] gives the name of the color
                content = Text(
                  GongSounds.names[index],
                  style: TextStyle(
                    fontSize: isSelected ? 24 : 20,
                    color: isSelected ? Colors.white : Colors.white.withOpacity(opacity),
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
    // Only dispose the controller if it was created here
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }
}


