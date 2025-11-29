import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/message/bloc/chat_controller.dart';
import 'package:ed_tech/modules/message/bloc/chatbot_cubit.dart';
import 'package:ed_tech/modules/message/screen/chat_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});
  static const String routeName = '/chatBotScreen';
  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      title: "chat.title".tr(),
      isShowDrawer: true,
      isShowBottomButton: false,
      actionsWidget: [
        InkWell(
          onTap:
              () => Navigator.pushNamed(context, ChatHistoryScreen.routeName),
          child: SvgPicture.asset(IconPath.iconHistory),
        ),
      ],
      screen: BlocListener<ChatbotCubit, ChatbotState>(
        listener: (context, state) {
          final controller = context.read<ChatController>();
          if (state is ChatbotSuccess) {
            controller.addMessage(
              ChatMessage(
                content: state.answer,
                isUser: false,
                timestamp: DateTime.now(),
              ),
            );
            controller.setBotResponding(false);
          } else if (state is ChatbotFailure || state is ChatbotError) {
            controller.addMessage(
              ChatMessage(
                content:
                    state is ChatbotFailure
                        ? state.message
                        : (state as ChatbotError).message,
                isUser: false,
                timestamp: DateTime.now(),
              ),
            );
            controller.setBotResponding(false);
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<List<ChatMessage>>(
                valueListenable: context.read<ChatController>().messages,
                builder: (context, messages, child) {
                  return ValueListenableBuilder<bool>(
                    valueListenable:
                        context.read<ChatController>().isBotResponding,
                    builder: (context, isBotResponding, child) {
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: messages.length + (isBotResponding ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index == messages.length && isBotResponding) {
                            return _LoadingMessageCard();
                          }
                          final message = messages[index];
                          return _MessageCard(message: message);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            _ChatInput(
              controller: _textController,
              onSend: () {
                final text = _textController.text.trim();
                if (text.isEmpty) return;

                final controller = context.read<ChatController>();
                final cubit = context.read<ChatbotCubit>();

                // Add user message
                controller.addMessage(
                  ChatMessage(
                    content: text,
                    isUser: true,
                    timestamp: DateTime.now(),
                  ),
                );

                // Set bot responding
                controller.setBotResponding(true);

                // Send to API
                cubit.sendMessage(message: text);

                _textController.clear();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final ChatMessage message;
  const _MessageCard({required this.message});

  void _copyToClipboard(BuildContext context, String text) {
    // Loại bỏ HTML tags để copy text thuần
    final cleanText = text.replaceAll(RegExp(r'<[^>]*>'), '');
    Clipboard.setData(ClipboardData(text: cleanText));

    // Hiển thị thông báo copy thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('chat.copied'.tr()),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser) ...[
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFEDEBFF),
            child: const Icon(
              Icons.smart_toy,
              size: 18,
              color: Color(0xFF6C56F9),
            ),
          ),
          const SizedBox(width: 10),
        ],

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF6C56F9) : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isUser ? const Color(0xFF6C56F9) : const Color(0xFFE7EAF0),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Text(
                      'chat.assistant_label'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C2439),
                      ),
                    ),
                  if (!isUser) const SizedBox(height: 2),
                  // Sử dụng flutter_html cho AI, Text cho user
                  if (isUser)
                    Text(
                      message.content,
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.4,
                        fontSize: 14,
                      ),
                    )
                  else
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color(0xFF1C2439),
                          fontSize: 14,
                          height: 1.4,
                        ),
                        children:
                            message.content
                                .split('<br>')
                                .map(
                                  (line) => TextSpan(
                                    text: line,
                                    children: [
                                      if (line !=
                                          message.content.split('<br>').last)
                                        const TextSpan(text: '\n'),
                                    ],
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (!isUser) ...[
                        _ActionIcon(
                          icon: Icons.copy_outlined,
                          label: 'chat.copy_text'.tr(),
                          onTap:
                              () => _copyToClipboard(context, message.content),
                        ),
                        const SizedBox(width: 10),
                        const _ActionIcon(icon: Icons.thumb_up_alt_outlined),
                        const SizedBox(width: 10),
                        const _ActionIcon(icon: Icons.thumb_down_alt_outlined),
                      ] else ...[
                        _ActionIcon(
                          icon: Icons.copy_outlined,
                          label: 'chat.copy_text'.tr(),
                          isWhite: true,
                          onTap:
                              () => _copyToClipboard(context, message.content),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isUser) ...[
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFDEE7FF),
            child: const Icon(Icons.person, size: 18, color: Color(0xFF386BF6)),
          ),
        ],
      ],
    );
  }
}

class _LoadingMessageCard extends StatelessWidget {
  const _LoadingMessageCard();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFFEDEBFF),
          child: const Icon(
            Icons.smart_toy,
            size: 18,
            color: Color(0xFF6C56F9),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE7EAF0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF6C56F9),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'chat.thinking'.tr(),
                    style: const TextStyle(color: Color(0xFF1C2439)),
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
  final bool isWhite;
  final VoidCallback? onTap;
  const _ActionIcon({
    required this.icon,
    this.label,
    this.isWhite = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        isWhite ? Colors.white.withOpacity(0.8) : const Color(0xFF8491A5);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(
              label!,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
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
                  const Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFF8491A5),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: AppTextStyles.text,
                      decoration: InputDecoration(
                        hintText: 'chat.input_hint'.tr(),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.attachment,
                      color: Color(0xFF8491A5),
                    ),
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
              decoration: const BoxDecoration(
                color: Color(0xFF6C56F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
