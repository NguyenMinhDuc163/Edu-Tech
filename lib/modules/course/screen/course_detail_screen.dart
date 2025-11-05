import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/modules/payment/screen/payment_method_screen.dart';
import 'package:ed_tech/modules/reviews/screen/review_screen.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/course/widgets/course_lesson_bottom_sheet.dart';
import 'package:ed_tech/modules/course/bloc/course_cubit.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

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
        String? videoUrl;
        if (content.files.isNotEmpty) {
          for (var file in content.files) {
            if (file.fileType == 'video') {
              videoUrl = file.url;
              break;
            }
          }
        }

        lessons.add(
          LessonData(
            id: content.contentId ?? '',
            title: content.title ?? '',
            duration: '0:00',
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
        if (content.files.isNotEmpty) {
          for (var file in content.files) {
            if (file.fileType == 'video') {
              return file.url;
            }
          }
        }
      }
    }
    return null;
  }

  void _playVideo(BuildContext context, String videoUrl, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _VideoPlayerScreen(
          videoUrl: videoUrl,
          title: title,
        ),
      ),
    );
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
    String? thumbnail = courseDetail?.thumbnailUrl ?? imageUrl;

    return _InlineVideoPlayer(
      videoUrl: videoUrl,
      thumbnail: thumbnail,
      title: title,
      onBack: () => Navigator.of(context).pop(),
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
    final sections = courseDetail?.sections ?? [];
    final totalLessons = _getTotalLessonsCount(sections);
    final sectionsToShow = totalLessons > 5 ? sections.take(2).toList() : sections;
    final hasMore = totalLessons > 5;

    return Padding(
      padding: AppPad.h24.add(const EdgeInsets.only(top: 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lessons', style: AppTextStyles.textHeader3.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          ...sectionsToShow.map((section) => _SectionItem(
            section: section,
            onPlayVideo: (videoUrl, title) => _playVideo(context, videoUrl, title),
          )),

          if (hasMore) ...[
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
        ],
      ),
    );
  }

  int _getTotalLessonsCount(List sections) {
    int count = 0;
    for (var section in sections) {
      count += (section.contents as List).length;
    }
    return count;
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

class _InlineVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final String? thumbnail;
  final String title;
  final VoidCallback onBack;

  const _InlineVideoPlayer({
    required this.videoUrl,
    required this.thumbnail,
    required this.title,
    required this.onBack,
  });

  @override
  State<_InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<_InlineVideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlaying = false;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    if (widget.videoUrl == null) return;

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl!),
    );

    await _videoPlayerController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
      allowMuting: true,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.colorFF6905,
        handleColor: AppColors.colorFF6905,
        backgroundColor: Colors.grey,
        bufferedColor: AppColors.colorFF6905.withOpacity(0.3),
      ),
      autoInitialize: true,
    );

    setState(() {
      _isPlaying = true;
    });
  }

  void _openFullscreenPlayer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _VideoPlayerScreen(
          videoUrl: widget.videoUrl!,
          title: widget.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      color: Colors.black,
      child: Stack(
        children: [
          if (_isPlaying && _chewieController != null)
            Positioned.fill(
              child: Chewie(controller: _chewieController!),
            )
          else
            Positioned.fill(
              child: widget.thumbnail != null
                  ? Image.network(
                      widget.thumbnail!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFEBF0), Color(0xFFFFF0F5)],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFFEBF0), Color(0xFFFFF0F5)],
                        ),
                      ),
                    ),
            ),

          if (!_isPlaying)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),

          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: widget.onBack,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),

          if (!_isPlaying && widget.videoUrl != null)
            Center(
              child: GestureDetector(
                onTap: _initializePlayer,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          if (_isPlaying && widget.videoUrl != null)
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () => _openFullscreenPlayer(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.fullscreen, color: Colors.white, size: 24),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const _VideoPlayerScreen({
    required this.videoUrl,
    required this.title,
  });

  @override
  State<_VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<_VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.primary,
        handleColor: AppColors.primary,
        backgroundColor: Colors.grey,
        bufferedColor: AppColors.primary.withOpacity(0.3),
      ),
      placeholder: Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      autoInitialize: true,
    );

    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
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
        title: Text(
          widget.title,
          style: AppTextStyles.textHeader3.copyWith(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _SectionItem extends StatefulWidget {
  final dynamic section;
  final Function(String videoUrl, String title) onPlayVideo;

  const _SectionItem({
    required this.section,
    required this.onPlayVideo,
  });

  @override
  State<_SectionItem> createState() => _SectionItemState();
}

class _SectionItemState extends State<_SectionItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final contents = widget.section.contents as List;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.section.title ?? '',
                          style: AppTextStyles.textContent1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.section.description != null &&
                            widget.section.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.section.description ?? '',
                            style: AppTextStyles.textContent3.copyWith(
                              color: AppColors.color8F959E,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.color8F959E,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightGray.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: contents.map((content) {
                  String? videoUrl;
                  if (content.files.isNotEmpty) {
                    for (var file in content.files) {
                      if (file.fileType == 'video') {
                        videoUrl = file.url;
                        break;
                      }
                    }
                  }

                  final hasVideo = videoUrl != null && videoUrl.isNotEmpty;

                  return InkWell(
                    onTap: hasVideo
                        ? () => widget.onPlayVideo(videoUrl!, content.title ?? '')
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.lightGray.withOpacity(0.5)),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (hasVideo)
                            Icon(
                              Icons.play_circle_outline,
                              color: AppColors.primary,
                              size: 24,
                            )
                          else
                            Icon(
                              Icons.description_outlined,
                              color: AppColors.color8F959E,
                              size: 24,
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  content.title ?? '',
                                  style: AppTextStyles.textContent2.copyWith(
                                    color: AppColors.text,
                                    fontWeight: hasVideo ? FontWeight.w500 : FontWeight.normal,
                                  ),
                                ),
                                if (content.description != null && content.description!.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    content.description ?? '',
                                    style: AppTextStyles.textContent3.copyWith(
                                      color: AppColors.color8F959E,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
