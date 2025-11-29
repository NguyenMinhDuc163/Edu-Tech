import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/modules/reviews/model/review_response.dart';
import 'package:ed_tech/modules/reviews/model/add_review_request.dart';

class ReviewRepo {
  final ApiClient apiClient;

  ReviewRepo({required this.apiClient});

  Future<ReviewData> getCourseReviews({
    required String courseId,
    int page = 1,
    int limit = 10,
  }) async {
    final res = await apiClient.fetch(
      '${ApiPath.courseReviews}/$courseId/reviews?page=$page&limit=$limit',
      RequestMethod.get,
    );

    if (res.code != 200) {
      throw Exception('Failed to fetch reviews: ${res.message}');
    }

    return ReviewData.fromJson(res.data);
  }

  Future<AddReviewData> addReview({
    required String courseId,
    required AddReviewRequest request,
  }) async {
    final res = await apiClient.fetch(
      '${ApiPath.courseReviews}/$courseId/reviews',
      RequestMethod.post,
      rawData: request.toJson(),
    );

    if (res.code != 201 && res.code != 200) {
      throw Exception('Failed to add review: ${res.message}');
    }

    return AddReviewData.fromJson(res.data);
  }
}
