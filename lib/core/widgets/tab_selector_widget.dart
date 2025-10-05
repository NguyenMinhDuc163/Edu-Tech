import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class TabSelectorWidget extends StatefulWidget {
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final List<String> tabs;
  final Set<int>? showDotAt; // indices with orange dot (e.g., notification)
  final Color selectedColor;
  final Color unselectedColor;
  final Color underlineColor;
  final double underlineWidth; // fixed underline width for simplicity
  final double underlineHeight;
  final double fontSize;

  const TabSelectorWidget({
    Key? key,
    this.initialIndex = 0,
    this.onTabChanged,
    required this.tabs,
    this.showDotAt,
    this.selectedColor = const Color(0xFF1C2439),
    this.unselectedColor = const Color(0xFF1C2439),
    this.underlineColor = const Color(0xFF386BF6),
    this.underlineWidth = 44,
    this.underlineHeight = 3,
    this.fontSize = 18,
  }) : super(key: key);

  @override
  State<TabSelectorWidget> createState() => _TabSelectorWidgetState();
}

class _TabSelectorWidgetState extends State<TabSelectorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController
        ..reset()
        ..forward();
      widget.onTabChanged?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabCount = widget.tabs.length;
        final tabWidth = constraints.maxWidth / tabCount;
        final indicatorLeft =
            _selectedIndex * tabWidth + (tabWidth - widget.underlineWidth) / 2;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  widget.tabs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final label = entry.value;
                    final isSelected = index == _selectedIndex;
                    final textColor =
                        isSelected
                            ? widget.selectedColor
                            : widget.unselectedColor.withOpacity(0.7);

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _onTabTapped(index),
                        child: SizedBox(
                          height: 36,
                          child: Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Text(
                                  label.tr(),
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: widget.fontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (widget.showDotAt?.contains(index) == true)
                                  Positioned(
                                    right: -14,
                                    top: -4,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF7A00), // orange dot
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 6),
            // Underline indicator
            SizedBox(
              height: widget.underlineHeight,
              child: Stack(
                children: [
                  Container(color: Colors.transparent),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    left: indicatorLeft,
                    child: Container(
                      width: widget.underlineWidth,
                      height: widget.underlineHeight,
                      decoration: BoxDecoration(
                        color: widget.underlineColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
