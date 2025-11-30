import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/modules/payment/screen/order_confirmation_screen.dart';
import 'package:ed_tech/modules/reviews/screen/review_screen.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/course/widgets/course_lesson_bottom_sheet.dart';
import 'package:ed_tech/modules/course/bloc/course_cubit.dart';
import 'package:ed_tech/modules/course/screen/course_cancellation_screen.dart';
import 'package:ed_tech/modules/assessment/screen/quiz_taking_screen.dart';
import 'package:ed_tech/modules/assessment/models/quiz_model.dart';
import 'package:ed_tech/modules/home/repository/home_repo.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CourseDetailScreen extends StatefulWidget {
  static const String routeName = '/CourseDetailScreen';

  const CourseDetailScreen({super.key});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi API chỉ 1 lần khi widget được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        final String courseId = args['courseId'] ?? '';
        context.read<CourseCubit>().getCourseDetail(courseId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(body: Center(child: Text('course.no_course_info'.tr())));
    }

    final String courseId = args['courseId'] ?? '';
    final String title = args['title'] ?? 'course.untitled'.tr();
    final String instructor = args['instructor'] ?? 'course.unknown_teacher'.tr();
    final String price = args['price'] ?? '0';
    final String duration = args['duration'] ?? '0h 0m';
    final String? imageUrl = args['imageUrl'];
    final String? description = args['description'];

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

class _CourseDetailContent extends StatefulWidget {
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

  @override
  State<_CourseDetailContent> createState() => _CourseDetailContentState();
}

class _CourseDetailContentState extends State<_CourseDetailContent> {
  bool _showBottomButton = true;
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    final size = _sheetController.size;
    final shouldShow = size <= 0.65;
    if (shouldShow != _showBottomButton) {
      setState(() {
        _showBottomButton = shouldShow;
      });
    }
  }

  void _showLessonBottomSheet(BuildContext context) {
    final sections = widget.courseDetail?.sections ?? [];
    final accessLevel = widget.courseDetail?.accessLevel ?? 'FREE';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CourseLessonBottomSheet(
        courseTitle: widget.title,
        sections: sections,
        accessLevel: accessLevel,
        onPlayVideo: (videoUrl, title, contentId) => _playVideo(context, videoUrl, title, contentId),
      ),
    );
  }

  String? _getFirstVideoUrl() {
    if (widget.courseDetail?.sections == null) return null;

    for (var section in widget.courseDetail.sections) {
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

  String? _getFirstVideoContentId() {
    if (widget.courseDetail?.sections == null) return null;

    for (var section in widget.courseDetail.sections) {
      for (var content in section.contents) {
        if (content.files.isNotEmpty) {
          for (var file in content.files) {
            if (file.fileType == 'video') {
              return content.contentId;
            }
          }
        }
      }
    }
    return null;
  }

  void _playVideo(BuildContext context, String videoUrl, String title, String? contentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _VideoPlayerScreen(
          videoUrl: videoUrl,
          title: title,
          contentId: contentId,
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
          if (_showBottomButton) _buildBottomActionButtons(context),
          if (!_showBottomButton) _buildFloatingActionButton(context),
        ],
      ),
    );
  }

  Widget _buildVideoPlayerSection(BuildContext context) {
    String? videoUrl = _getFirstVideoUrl();
    String? contentId = _getFirstVideoContentId();
    String? thumbnail = widget.courseDetail?.thumbnailUrl ?? widget.imageUrl;

    return _InlineVideoPlayer(
      videoUrl: videoUrl,
      contentId: contentId,
      thumbnail: thumbnail,
      title: widget.title,
      onBack: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
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
    final accessLevel = widget.courseDetail?.accessLevel ?? 'FREE';
    final hasFullAccess = accessLevel == 'FULL';
    final daysLeftToCancel = widget.courseDetail?.daysLeftToCancel ?? 0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: _showBottomButton ? 0 : -100,
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
              color: Colors.black.withAlpha(26),
            ),
          ],
        ),
        child: hasFullAccess && daysLeftToCancel > 0
            ? _buildEnrolledWithCancelLayout(context, daysLeftToCancel)
            : Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ReviewScreen.routeName,
                        arguments: {'courseId': widget.courseId},
                      );
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
                    child: hasFullAccess ? _buildEnrolledButton(context) : _buildBuyButton(context),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final accessLevel = widget.courseDetail?.accessLevel ?? 'FREE';
    final hasFullAccess = accessLevel == 'FULL';

    return Positioned(
      bottom: 24,
      right: 24,
      child: FloatingActionButton.extended(
        onPressed: () {
          if (hasFullAccess) {
            _showLessonBottomSheet(context);
          } else {
            _handleBuyAction(context);
          }
        },
        backgroundColor: hasFullAccess ? AppColors.success : AppColors.primary,
        elevation: 6,
        label: Row(
          children: [
            Icon(
              hasFullAccess ? Icons.play_circle_filled : Icons.shopping_cart,
              color: AppColors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              hasFullAccess ? 'course.continue_learning'.tr() : 'course.buy_now'.tr(),
              style: AppTextStyles.button.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleBuyAction(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      OrderConfirmationScreen.routeName,
      arguments: {
        'courseId': widget.courseId,
        'title': widget.title,
        'instructor': widget.instructor,
        'price': widget.price,
        'duration': widget.duration,
        'thumbnailUrl': widget.courseDetail?.thumbnailUrl ?? widget.imageUrl,
      },
    );

    if (result == true && context.mounted) {
      context.read<CourseCubit>().getCourseDetail(widget.courseId);
    }
  }

  Widget _buildEnrolledWithCancelLayout(BuildContext context, int daysLeft) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.colorFF6905.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.colorFF6905.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                color: AppColors.colorFF6905,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'course.days_left_to_cancel'.tr().replaceAll('{days}', daysLeft.toString()),
                style: AppTextStyles.textContent3.copyWith(
                  color: AppColors.colorFF6905,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ReviewScreen.routeName,
                  arguments: {'courseId': widget.courseId},
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.colorFFEBF0,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.colorFF6905),
                ),
                child: const Icon(Icons.star_border, color: AppColors.colorFF6905, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: _buildEnrolledButton(context),
            ),
            const SizedBox(width: 12),
            _buildCancelButton(context, daysLeft),
          ],
        ),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context, int daysLeft) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error, width: 1.5),
      ),
      child: TextButton(
        onPressed: () => _showCancelCourseDialog(context, daysLeft),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Icon(
          Icons.cancel_outlined,
          color: AppColors.error,
          size: 20,
        ),
      ),
    );
  }

  void _showCancelCourseDialog(BuildContext context, int daysLeft) async {
    final courseCubit = context.read<CourseCubit>();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: courseCubit,
          child: CourseCancellationScreen(
            courseId: widget.courseId,
            courseTitle: widget.title,
            daysLeftToCancel: daysLeft,
          ),
        ),
      ),
    );

    if (result == true && context.mounted) {
      courseCubit.getCourseDetail(widget.courseId);
    }
  }

  Widget _buildBuyButton(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.primary, AppColors.color0961F5],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(102),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () => _handleBuyAction(context),
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'course.buy_now'.tr(),
              style: AppTextStyles.button.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward,
              color: AppColors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnrolledButton(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.success,
            AppColors.success.withAlpha(204),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {
          _showLessonBottomSheet(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'course.continue_learning'.tr(),
              style: AppTextStyles.button.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
              widget.title,
              style: AppTextStyles.textHeader2.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            widget.price,
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
            'course.about_this_course'.tr(),
            style: AppTextStyles.textHeader3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            widget.description ??
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
    final sections = widget.courseDetail?.sections ?? [];
    final totalLessons = _getTotalLessonsCount(sections);
    final sectionsToShow = totalLessons > 5 ? sections.take(2).toList() : sections;
    final hasMore = totalLessons > 5;

    return Padding(
      padding: AppPad.h24.add(const EdgeInsets.only(top: 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('course.lessons_title'.tr(), style: AppTextStyles.textHeader3.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          ...sectionsToShow.map((section) => _SectionItem(
            section: section,
            onPlayVideo: (videoUrl, title, contentId) => _playVideo(context, videoUrl, title, contentId),
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
                  'course.view_all_lessons'.tr(),
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

class _InlineVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final String? contentId;
  final String? thumbnail;
  final String title;
  final VoidCallback onBack;

  const _InlineVideoPlayer({
    required this.videoUrl,
    this.contentId,
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
    String? contentIdToSave;
    double? progressToSave;

    if (widget.contentId != null && _videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      final currentPosition = _videoPlayerController!.value.position.inSeconds;
      final totalDuration = _videoPlayerController!.value.duration.inSeconds;

      if (totalDuration > 0) {
        contentIdToSave = widget.contentId;
        progressToSave = currentPosition / totalDuration;
      }
    }

    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();

    if (contentIdToSave != null && progressToSave != null) {
      _saveVideoProgress(contentIdToSave, progressToSave);
    }
  }

  void _saveVideoProgress(String contentId, double progressPercentage) {
    try {
      final repo = HomeRepo(apiClient: ApiClient());
      repo.saveVideoProgress(
        contentId: contentId,
        progressPercentage: progressPercentage,
      );
    } catch (_) {}
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
          contentId: widget.contentId,
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
  final String? contentId;

  const _VideoPlayerScreen({
    required this.videoUrl,
    required this.title,
    this.contentId,
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
    String? contentIdToSave;
    double? progressToSave;

    if (widget.contentId != null && _videoPlayerController.value.isInitialized) {
      final currentPosition = _videoPlayerController.value.position.inSeconds;
      final totalDuration = _videoPlayerController.value.duration.inSeconds;

      if (totalDuration > 0) {
        contentIdToSave = widget.contentId;
        progressToSave = currentPosition / totalDuration;
      }
    }

    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();

    if (contentIdToSave != null && progressToSave != null) {
      _saveVideoProgress(contentIdToSave, progressToSave);
    }
  }

  void _saveVideoProgress(String contentId, double progressPercentage) {
    try {
      final repo = HomeRepo(apiClient: ApiClient());
      repo.saveVideoProgress(
        contentId: contentId,
        progressPercentage: progressPercentage,
      );
    } catch (_) {}
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
  final Function(String videoUrl, String title, String? contentId) onPlayVideo;

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
                  final hasQuiz = content.quiz != null;

                  return InkWell(
                    onTap: hasQuiz
                        ? () {
                            final quiz = content.quiz!;
                            final quizModel = QuizModel(
                              id: quiz.questionBankId ?? '',
                              title: quiz.quizTitle ?? '',
                              type: 'ASSIGNMENT',
                              timeLimit: 0,
                              questionCount: 0,
                              status: QuizStatus.notTaken,
                              attempts: 0,
                              subject: '',
                            );
                            Navigator.pushNamed(
                              context,
                              QuizTakingScreen.routeName,
                              arguments: {'quiz': quizModel},
                            );
                          }
                        : hasVideo
                            ? () => widget.onPlayVideo(videoUrl!, content.title ?? '', content.contentId)
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
                          if (hasQuiz)
                            Icon(
                              Icons.quiz_outlined,
                              color: AppColors.success,
                              size: 24,
                            )
                          else if (hasVideo)
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
                                    fontWeight: hasVideo || hasQuiz ? FontWeight.w500 : FontWeight.normal,
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
