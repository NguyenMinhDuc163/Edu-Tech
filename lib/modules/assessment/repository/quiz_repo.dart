import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/modules/assessment/models/list_quiz_model.dart';
import 'package:ed_tech/modules/assessment/models/detail_quiz_model.dart';
import 'package:ed_tech/modules/assessment/models/submit_quiz_model.dart';

class QuizRepo {
  final ApiClient apiClient;
  QuizRepo({required this.apiClient});

  Future<ListQuizModel> getListQuiz({
    String? courseId,
    String? sectionId,
    String? lessonId,
  }) async {
    final Map<String, dynamic> rawData = {};

    if (courseId != null) rawData['course_id'] = courseId;
    if (sectionId != null) rawData['section_id'] = sectionId;
    if (lessonId != null) rawData['lesson_id'] = lessonId;

    final res = await apiClient.fetch(
      ApiPath.listQuiz,
      RequestMethod.post,
      rawData: rawData.isNotEmpty ? rawData : null,
    );

    final response = ListQuizModel.fromJson(res.json);

    if (response.status != 200) {
      throw Exception(response.message ?? 'Lấy danh sách quiz thất bại');
    }

    return response;
  }

  Future<DetailQuizModel> getQuizDetail({required String quizId}) async {
    final res = await apiClient.fetch(
      ApiPath.quizDetail,
      RequestMethod.post,
      rawData: {"quiz_id": quizId},
    );

    final response = DetailQuizModel.fromJson(res.json);

    if (response.status != 200) {
      throw Exception(response.message ?? 'Lấy chi tiết quiz thất bại');
    }

    return response;
  }

  Future<SubmitQuizModel> submitQuiz({
    required String quizId,
    required List<Map<String, String>> answers,
  }) async {
    final rawData = {"quiz_id": quizId, "answers": answers};

    final res = await apiClient.fetch(
      ApiPath.submitQuiz,
      RequestMethod.post,
      rawData: rawData,
    );

    final response = SubmitQuizModel.fromJson(res.json);

    if (response.status != 200) {
      throw Exception(response.message ?? 'Nộp bài thi thất bại');
    }

    return response;
  }
}
