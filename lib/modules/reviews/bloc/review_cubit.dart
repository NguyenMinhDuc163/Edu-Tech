import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/reviews/model/review_response.dart';
import 'package:ed_tech/modules/reviews/model/add_review_request.dart';
import 'package:ed_tech/modules/reviews/repository/review_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepo repo;

  ReviewCubit({required this.repo}) : super(ReviewInitial());

  Future<void> getReviews({
    required String courseId,
    int page = 1,
    int limit = 10,
  }) async {
    emit(ReviewProgress());
    try {
      final reviewData = await repo.getCourseReviews(
        courseId: courseId,
        page: page,
        limit: limit,
      );
      emit(ReviewSuccess(reviewData: reviewData));
    } catch (e) {
      emit(ReviewError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }

  Future<void> addReview({
    required String courseId,
    required AddReviewRequest request,
  }) async {
    emit(AddReviewProgress());
    try {
      final reviewData = await repo.addReview(
        courseId: courseId,
        request: request,
      );
      emit(AddReviewSuccess(reviewData: reviewData));
    } catch (e) {
      emit(AddReviewError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }

  void reset() {
    emit(ReviewInitial());
  }
}
