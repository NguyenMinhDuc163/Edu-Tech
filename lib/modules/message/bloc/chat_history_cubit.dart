import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/message/repository/chat_sessions_repo.dart';
import 'package:ed_tech/modules/message/model/sessions_response.dart';

part 'chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  final ChatSessionsRepo repo;

  ChatHistoryCubit({required this.repo}) : super(ChatHistoryInitial());

  Future<void> loadSessions({int page = 1, int limit = 10}) async {
    emit(ChatHistoryLoading());
    try {
      final response = await repo.getSessions(page: page, limit: limit);

      if (response.status == 200 && response.data != null) {
        emit(
          ChatHistorySuccess(
            sessions: response.data!.sessions,
            total: response.data!.total,
            currentPage: response.data!.page,
            limit: response.data!.limit,
          ),
        );
      } else {
        emit(
          ChatHistoryFailure(
              message: response.message ?? 'Lấy danh sách phiên chat thất bại'),
        );
      }
    } catch (e) {
      emit(ChatHistoryError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }

  Future<void> loadMoreSessions() async {
    final currentState = state;
    if (currentState is! ChatHistorySuccess || !currentState.hasMore) return;

    try {
      final nextPage = currentState.currentPage + 1;
      final response =
          await repo.getSessions(page: nextPage, limit: currentState.limit);

      if (response.status == 200 && response.data != null) {
        final allSessions = [
          ...currentState.sessions,
          ...response.data!.sessions,
        ];

        emit(
          ChatHistorySuccess(
            sessions: allSessions,
            total: response.data!.total,
            currentPage: response.data!.page,
            limit: response.data!.limit,
          ),
        );
      }
    } catch (e) {
      emit(ChatHistoryError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }

  Future<void> deleteSession(String sessionId) async {
    final currentState = state;
    if (currentState is! ChatHistorySuccess) return;

    final updatedSessions = currentState.sessions
        .where((session) => session.sessionId != sessionId)
        .toList();

    emit(
      ChatHistorySuccess(
        sessions: updatedSessions,
        total: currentState.total - 1,
        currentPage: currentState.currentPage,
        limit: currentState.limit,
      ),
    );

    try {
      await repo.deleteSession(sessionId: sessionId);
    } catch (e) {
      emit(
        ChatHistorySuccess(
          sessions: currentState.sessions,
          total: currentState.total,
          currentPage: currentState.currentPage,
          limit: currentState.limit,
        ),
      );

      emit(ChatHistoryError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }

  Future<void> deleteAllSessions() async {
    final currentState = state;
    if (currentState is! ChatHistorySuccess) return;

    emit(ChatHistoryLoading());

    try {
      await repo.deleteSession(sessionId: '');
      emit(
        ChatHistorySuccess(
          sessions: [],
          total: 0,
          currentPage: 1,
          limit: currentState.limit,
        ),
      );
    } catch (e) {
      emit(
        ChatHistorySuccess(
          sessions: currentState.sessions,
          total: currentState.total,
          currentPage: currentState.currentPage,
          limit: currentState.limit,
        ),
      );

      emit(ChatHistoryError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }
}
