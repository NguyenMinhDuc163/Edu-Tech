import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class TabSelectorWidget extends StatefulWidget {
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final List<String> tabs;

  const TabSelectorWidget({
    Key? key,
    this.initialIndex = 0,
    this.onTabChanged,
    required this.tabs,
  }) : super(key: key);

  @override
  State<TabSelectorWidget> createState() => _TabSelectorWidgetState();
}

class _TabSelectorWidgetState extends State<TabSelectorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
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
      _animationController.reset();
      _animationController.forward();
      widget.onTabChanged?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1), // Light teal background
        borderRadius: BorderRadius.circular(25), // Pill shape
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / widget.tabs.length;

          return Stack(
            children: [
              // Animated background for selected tab
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Positioned(
                    left: _selectedIndex * tabWidth + 3,
                    top: 3,
                    child: Container(
                      width: tabWidth - 6,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF4DB6AC,
                        ), // Darker teal for selected
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Tab buttons
              Row(
                children:
                    widget.tabs.asMap().entries.map((entry) {
                      int index = entry.key;
                      String tab = entry.value;
                      bool isSelected = index == _selectedIndex;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _onTabTapped(index),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                tab.tr(),
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : const Color(0xFF666666),
                                  fontSize: 16,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
