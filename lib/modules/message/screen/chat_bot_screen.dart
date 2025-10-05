import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/message/screen/chat_history_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});
  static const String routeName = '/chatBotScreen';
  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _textController = TextEditingController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(isUser: true, text: 'What is AI chat bot ?'),
    _ChatMessage(
      isUser: false,
      text:
          'An AI chatbot is a computer program designed to simulate human conversation through text or voice interactions. What sets it apart from traditional chatbots is its ability to understand and respond to user input in a natural, human-like way.',
    ),
    _ChatMessage(isUser: true, text: 'How Does it Work?'),
    _ChatMessage(
      isUser: false,
      text:
          'User Input:\nYou type or speak a message.\nProcessing:\nThe chatbot\'s AI analyzes your message to understand its meaning.',
    ),
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      title: "Chat Bot",
      isShowDrawer: true,
      isShowBottomButton: false,
      actionsWidget: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, ChatHistoryScreen.routeName),
          child: SvgPicture.asset(IconPath.iconHistory),
        ),
      ],
      screen: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageCard(message: message);
              },
            ),
          ),
          const SizedBox(height: 4),
          _ChatInput(
            controller: _textController,
            onSend: () {
              final text = _textController.text.trim();
              if (text.isEmpty) return;
              setState(() {
                _messages.add(_ChatMessage(isUser: true, text: text));
              });
              _textController.clear();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final bool isUser;
  final String text;
  _ChatMessage({required this.isUser, required this.text});
}

class _MessageCard extends StatelessWidget {
  final _ChatMessage message;
  const _MessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;
    final Color borderColor = const Color(0xFFE7EAF0);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isUser ? const Color(0xFFDEE7FF) : const Color(0xFFEDEBFF),
          child: Icon(
            isUser ? Icons.person : Icons.smart_toy,
            size: 18,
            color: isUser ? const Color(0xFF386BF6) : const Color(0xFF6C56F9),
          ),
        ),
        const SizedBox(width: 10),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    const Text(
                      'User Input:',
                      style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1C2439)),
                    ),
                  if (!isUser) const SizedBox(height: 2),
                  Text(message.text, style: const TextStyle(color: Color(0xFF1C2439), height: 1.4)),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      _ActionIcon(icon: Icons.copy_outlined, label: 'Copy Text'),
                      SizedBox(width: 10),
                      _ActionIcon(icon: Icons.thumb_up_alt_outlined),
                      SizedBox(width: 10),
                      _ActionIcon(icon: Icons.thumb_down_alt_outlined),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String? label;
  const _ActionIcon({required this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    final Color color = const Color(0xFF8491A5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        if (label != null) ...[
          const SizedBox(width: 6),
          Text(label!, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ],
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _ChatInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE7EAF0)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search, color: Color(0xFF8491A5)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask ai chat anything',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attachment, color: Color(0xFF8491A5)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(color: Color(0xFF6C56F9), shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
