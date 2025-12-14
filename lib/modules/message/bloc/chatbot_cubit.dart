import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/message/repository/chat_bot_repo.dart';

part 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final ChatBotRepo repo;

  ChatbotCubit({required this.repo}) : super(ChatbotInitial());

  Future<void> sendMessage({
    required String message,
    String? sessionId,
  }) async {
    emit(ChatbotInProgress());
    try {
      final response = await repo.sendMessage(
        message: message,
        sessionId: sessionId,
      );

      if (response.status == 200 && response.data != null) {
        emit(
          ChatbotSuccess(
            responseHtml: response.data!.responseHtml ?? '',
            responseRaw: response.data!.responseRaw ?? '',
            sessionId: response.data!.sessionId?.toString() ?? '',
          ),
        );
      } else {
        emit(
          ChatbotFailure(message: response.message ?? 'Gửi tin nhắn thất bại'),
        );
      }
    } catch (e) {
      emit(ChatbotError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }
}
