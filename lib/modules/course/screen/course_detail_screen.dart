import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/modules/payment/screen/payment_method_screen.dart';
import 'package:ed_tech/modules/reviews/screen/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/course/widgets/course_lesson_bottom_sheet.dart';
import 'package:ed_tech/modules/course/bloc/course_cubit.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseDetailScreen extends StatelessWidget {
  static const String routeName = '/CourseDetailScreen';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(body: Center(child: Text('Không có thông tin khóa học')));
    }

    final String courseId = args['courseId'] ?? '';
    final String title = args['title'] ?? 'Untitled Course';
    final String instructor = args['instructor'] ?? 'Unknown Teacher';
    final String price = args['price'] ?? '0';
    final String duration = args['duration'] ?? '0h 0m';
    final String? imageUrl = args['imageUrl'];
    final String? description = args['description'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseCubit>().getCourseDetail(courseId);
    });

    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseDetailProgress) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is CourseDetailSuccess) {
          final courseData = state.courseDetail;
          return _CourseDetailContent(
            courseId: courseId,
            title: courseData.title ?? title,
            instructor: instructor,
            price: courseData.price ?? price,
            duration: duration,
            imageUrl: imageUrl,
            description: courseData.description ?? description,
            courseDetail: courseData,
          );
        }

        return _CourseDetailContent(
          courseId: courseId,
          title: title,
          instructor: instructor,
          price: price,
          duration: duration,
          imageUrl: imageUrl,
          description: description,
        );
      },
    );
  }
}

class _CourseDetailContent extends StatelessWidget {
  final String courseId;
  final String title;
  final String instructor;
  final String price;
  final String duration;
  final String? imageUrl;
  final String? description;
  final dynamic courseDetail;

  const _CourseDetailContent({
    required this.courseId,
    required this.title,
    required this.instructor,
    required this.price,
    required this.duration,
    this.imageUrl,
    this.description,
    this.courseDetail,
  });

  void _showLessonBottomSheet(BuildContext context) {
    List<LessonData> lessons =
        courseDetail?.sections != null
            ? _getLessonsFromApi(courseDetail.sections)
            : _getSampleLessons();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CourseLessonBottomSheet(courseTitle: title, lessons: lessons),
    );
  }

  List<LessonData> _getSampleLessons() {
    return [
      const LessonData(
        id: '1',
        title: 'Welcome to the Course',
        duration: '6:10 mins',
        isCompleted: true,
        isLocked: false,
      ),
      const LessonData(
        id: '2',
        title: 'Process overview',
        duration: '6:10 mins',
        isCompleted: false,
        isLocked: false,
      ),
      const LessonData(
        id: '3',
        title: 'Discovery',
        duration: '6:10 mins',
        isCompleted: false,
        isLocked: true,
      ),
      const LessonData(
        id: '4',
        title: 'User Research',
        duration: '8:15 mins',
        isCompleted: false,
        isLocked: true,
      ),
      const LessonData(
        id: '5',
        title: 'Wireframing',
        duration: '12:30 mins',
        isCompleted: false,
        isLocked: true,
      ),
    ];
  }

  List<LessonData> _getLessonsFromApi(List sections) {
    List<LessonData> lessons = [];
    for (var section in sections) {
      for (var content in section.contents) {
        String duration = '0:00 mins';
        String? videoUrl;

        for (var file in content.files) {
          if (file.fileType == 'video' || file.url?.contains('youtube') == true) {
            videoUrl = file.url;
            break;
          }
        }

        lessons.add(
          LessonData(
            id: content.contentId ?? '',
            title: content.title ?? 'Untitled Lesson',
            duration: duration,
            isCompleted: false,
            isLocked: !(content.isPreview ?? false),
            videoUrl: videoUrl,
          ),
        );
      }
    }
    return lessons;
  }

  String? _getFirstVideoUrl() {
    if (courseDetail?.sections == null) return null;

    for (var section in courseDetail.sections) {
      for (var content in section.contents) {
        for (var file in content.files) {
          if (file.fileType == 'video' || file.url?.contains('youtube') == true) {
            return file.url;
          }
        }
      }
    }
    return null;
  }

  String _getYouTubeThumbnail(String videoUrl) {
    String videoId = '';
    if (videoUrl.contains('youtube.com/watch?v=')) {
      videoId = videoUrl.split('v=')[1].split('&')[0];
    } else if (videoUrl.contains('youtu.be/')) {
      videoId = videoUrl.split('youtu.be/')[1].split('?')[0];
    }

    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }

  void _playYouTubeVideo(BuildContext context, String videoUrl) {
    String videoId = '';
    if (videoUrl.contains('youtube.com/watch?v=')) {
      videoId = videoUrl.split('v=')[1].split('&')[0];
    } else if (videoUrl.contains('youtu.be/')) {
      videoId = videoUrl.split('youtu.be/')[1].split('?')[0];
    }

    if (videoId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _YouTubePlayerScreen(videoId: videoId)),
      );
    }
  }

  void _playLessonVideo(LessonData lesson, BuildContext context) {
    print('🎬 Playing lesson from preview: ${lesson.title}');
    print('🎬 Lesson videoUrl: ${lesson.videoUrl}');

    if (lesson.videoUrl != null && lesson.videoUrl!.isNotEmpty) {
      print('🎬 Opening video: ${lesson.videoUrl}');
      _playYouTubeVideo(context, lesson.videoUrl!);
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(lesson.title),
              content: const Text('Video không khả dụng'),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Đóng')),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          _buildVideoPlayerSection(context),
          _buildBottomSheet(context),
          _buildBottomActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildVideoPlayerSection(BuildContext context) {
    String? videoUrl = _getFirstVideoUrl();

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFEBF0), Color(0xFFFFF0F5)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),

          Center(
            child: GestureDetector(
              onTap: videoUrl != null ? () => _playYouTubeVideo(context, videoUrl) : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child:
                        videoUrl != null
                            ? Stack(
                              children: [
                                const Center(
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    size: 80,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            )
                            : const Icon(
                              Icons.play_circle_outline,
                              size: 80,
                              color: AppColors.primary,
                            ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '4:10',
                      style: AppTextStyles.textContent3.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '6:10',
                      style: AppTextStyles.textContent3.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.68,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorFF6905,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.fullscreen, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            border: Border.all(color: AppColors.lightGray.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 10,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                _buildCourseDetailsSection(),

                _buildAboutSection(),

                _buildLessonsPreviewSection(context),

                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActionButtons(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: AppPad.h24.add(AppPad.v20),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 10,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ReviewScreen.routeName);
              },
              child: Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.colorFFEBF0,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.colorFF6905),
                ),
                child: const Icon(Icons.star_border, color: AppColors.colorFF6905, size: 24),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PaymentMethodScreen.routeName);
                  },
                  child: Text('Buy Now', style: AppTextStyles.button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseDetailsSection() {
    return Container(
      padding: AppPad.h24.add(AppPad.v20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.textHeader2.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            price,
            style: AppTextStyles.textHeader2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: AppPad.h24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this course',
            style: AppTextStyles.textHeader3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            description ??
                'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
            style: AppTextStyles.textContent2.copyWith(color: AppColors.color8F959E, height: 1.5),
          ),
          const SizedBox(height: 16),
          const Icon(Icons.visibility_off, color: AppColors.color8F959E, size: 20),
        ],
      ),
    );
  }

  Widget _buildLessonsPreviewSection(BuildContext context) {
    return Padding(
      padding: AppPad.h24.add(const EdgeInsets.only(top: 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lessons', style: AppTextStyles.textHeader3.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          ..._getLessonsFromApi(
            courseDetail?.sections ?? [],
          ).take(3).map((lesson) => _buildLessonItem(lesson, context)),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () => _showLessonBottomSheet(context),
            child: Container(
              width: double.infinity,
              padding: AppPad.v12,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'View All Lessons',
                textAlign: TextAlign.center,
                style: AppTextStyles.textButton.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(LessonData lesson, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                lesson.id.padLeft(2, '0'),
                style: AppTextStyles.textContent2.copyWith(
                  color: AppColors.color8F959E,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: AppTextStyles.textContent1.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.duration,
                  style: AppTextStyles.textContent3.copyWith(color: AppColors.color8F959E),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: lesson.isLocked ? null : () => _playLessonVideo(lesson, context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: lesson.isLocked ? AppColors.lightGray : AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                lesson.isLocked ? Icons.lock : Icons.play_arrow,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LessonData {
  final String id;
  final String title;
  final String duration;
  final bool isCompleted;
  final bool isLocked;
  final String? videoUrl;

  const LessonData({
    required this.id,
    required this.title,
    required this.duration,
    required this.isCompleted,
    required this.isLocked,
    this.videoUrl,
  });
}

class _YouTubePlayerScreen extends StatefulWidget {
  final String videoId;

  const _YouTubePlayerScreen({required this.videoId});

  @override
  State<_YouTubePlayerScreen> createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<_YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false, isLive: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Video Player', style: AppTextStyles.textHeader3.copyWith(color: Colors.white)),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: AppColors.primary,
          progressColors: const ProgressBarColors(
            playedColor: AppColors.primary,
            handleColor: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
