import 'package:ed_tech/init.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});
  static const String routeName = '/chatHistoryScreen';

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  
  final Map<String, List<String>> _groups = {
    'Today': ['What is AI chat bot', 'Real Estate brand Names'],
    'Yesterday, May 27': [
      'What is AI chat bot',
      'Improve the readability of the following code',
      'Suggest a Python library to solve a problem',
    ],
  };

  
  String? _selectedGroup;
  int? _selectedIndex;

  void _onClearAll() {
    setState(() {
      _groups.updateAll((key, value) => []);
      _selectedGroup = null;
      _selectedIndex = null;
    });
  }

  void _toggleSelect(String group, int index) {
    setState(() {
      if (_selectedGroup == group && _selectedIndex == index) {
        _selectedGroup = null;
        _selectedIndex = null;
      } else {
        _selectedGroup = group;
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      title: 'History',
      actionsWidget: [
        TextButton(
          onPressed: _onClearAll,
          child: const Text(
            'Clear all',
            style: TextStyle(
              color: Color(0xFF6C56F9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      screen: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children:
            _groups.entries.expand((entry) {
              final groupTitle = entry.key;
              final items = entry.value;
              return [
                _SectionHeader(title: groupTitle),
                const SizedBox(height: 8),
                ...List.generate(items.length, (index) {
                  final isSelected =
                      _selectedGroup == groupTitle && _selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _HistoryItem(
                      title: items[index],
                      isSelected: isSelected,
                      onTap: () => _toggleSelect(groupTitle, index),
                      onEdit: () {},
                      onDelete: () {
                        setState(() {
                          items.removeAt(index);
                          _selectedGroup = null;
                          _selectedIndex = null;
                        });
                      },
                    ),
                  );
                }),
              ];
            }).toList(),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF8B97A8),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HistoryItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Color bubbleColor = const Color(0xFFF6F7FF);
    final Color iconColor = const Color(0xFF8B97A8);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE7EAF0)),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: iconColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1C2439),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isSelected) ...[
          const SizedBox(width: 10),
          _ActionSquare(
            icon: Icons.edit,
            bgColor: const Color(0xFFEDEBFF),
            iconColor: const Color(0xFF6C56F9),
            onTap: onEdit,
          ),
          const SizedBox(width: 10),
          _ActionSquare(
            icon: Icons.delete_outline,
            bgColor: const Color(0xFFFFE9E7),
            iconColor: const Color(0xFFFF6B60),
            onTap: onDelete,
          ),
        ],
      ],
    );
  }
}

class _ActionSquare extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;
  const _ActionSquare({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}
