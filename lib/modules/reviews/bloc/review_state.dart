part of 'review_cubit.dart';

@immutable
sealed class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewProgress extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final ReviewData reviewData;

  ReviewSuccess({required this.reviewData});
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError({this.message = 'Đã xảy ra lỗi'});
}

class AddReviewProgress extends ReviewState {}

class AddReviewSuccess extends ReviewState {
  final AddReviewData reviewData;

  AddReviewSuccess({required this.reviewData});
}

class AddReviewError extends ReviewState {
  final String message;

  AddReviewError({this.message = 'Đã xảy ra lỗi'});
}
