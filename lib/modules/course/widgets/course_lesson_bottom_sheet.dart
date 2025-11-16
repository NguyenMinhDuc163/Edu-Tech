import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/course/model/detail_course.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CourseLessonBottomSheet extends StatelessWidget {
  final String courseTitle;
  final List<Section> sections;
  final String accessLevel;
  final Function(String videoUrl, String title)? onPlayVideo;

  const CourseLessonBottomSheet({
    super.key,
    required this.courseTitle,
    required this.sections,
    required this.accessLevel,
    this.onPlayVideo,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 10,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
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
              Padding(
                padding: AppPad.h24.add(const EdgeInsets.only(top: 20, bottom: 16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'course.course_content'.tr(),
                            style: AppTextStyles.textHeader3.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            courseTitle,
                            style: AppTextStyles.textContent2.copyWith(
                              color: AppColors.color8F959E,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.text,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: sections.isEmpty
                    ? Center(
                        child: Text(
                          'course.no_content'.tr(),
                          style: AppTextStyles.textContent2.copyWith(
                            color: AppColors.color8F959E,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: AppPad.h24.add(AppPad.b20),
                        itemCount: sections.length,
                        itemBuilder: (context, index) {
                          final section = sections[index];
                          return _SectionItem(
                            section: section,
                            sectionIndex: index + 1,
                            accessLevel: accessLevel,
                            onPlayVideo: onPlayVideo,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionItem extends StatefulWidget {
  final Section section;
  final int sectionIndex;
  final String accessLevel;
  final Function(String videoUrl, String title)? onPlayVideo;

  const _SectionItem({
    required this.section,
    required this.sectionIndex,
    required this.accessLevel,
    this.onPlayVideo,
  });

  @override
  State<_SectionItem> createState() => _SectionItemState();
}

class _SectionItemState extends State<_SectionItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasFullAccess = widget.accessLevel == 'FULL';
    final contentCount = widget.section.contents.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpanded ? AppColors.primary.withOpacity(0.3) : AppColors.lightGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 8,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        widget.sectionIndex.toString(),
                        style: AppTextStyles.textContent1.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.section.title ?? '',
                          style: AppTextStyles.textContent1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                        const SizedBox(height: 4),
                        Text(
                          '$contentCount ${'course.lessons'.tr().toLowerCase()}',
                          style: AppTextStyles.textContent3.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                color: AppColors.lightGray.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: widget.section.contents.asMap().entries.map((entry) {
                  final index = entry.key;
                  final content = entry.value;
                  return _ContentItem(
                    content: content,
                    contentIndex: index + 1,
                    hasFullAccess: hasFullAccess,
                    onPlayVideo: widget.onPlayVideo,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContentItem extends StatefulWidget {
  final Content content;
  final int contentIndex;
  final bool hasFullAccess;
  final Function(String videoUrl, String title)? onPlayVideo;

  const _ContentItem({
    required this.content,
    required this.contentIndex,
    required this.hasFullAccess,
    this.onPlayVideo,
  });

  @override
  State<_ContentItem> createState() => _ContentItemState();
}

class _ContentItemState extends State<_ContentItem> {
  bool _isExpanded = false;

  String? _getVideoUrl() {
    if (widget.content.files.isEmpty) return null;
    for (var file in widget.content.files) {
      if (file.fileType == 'video' && file.url != null) {
        return file.url;
      }
    }
    return null;
  }

  bool get _isLocked {
    if (widget.hasFullAccess) return false;
    return !(widget.content.isPreview ?? false);
  }

  void _handleTap() {
    if (_isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('course.purchase_to_unlock'.tr()),
          backgroundColor: AppColors.colorFF6905,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final videoUrl = _getVideoUrl();
    if (videoUrl != null && videoUrl.isNotEmpty) {
      if (widget.onPlayVideo != null) {
        widget.onPlayVideo!(videoUrl, widget.content.title ?? '');
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _VideoPlayerScreen(
              videoUrl: videoUrl,
              title: widget.content.title ?? '',
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoUrl = _getVideoUrl();
    final hasVideo = videoUrl != null && videoUrl.isNotEmpty;
    final hasDescription = widget.content.description != null &&
                          widget.content.description!.isNotEmpty;

    return Column(
      children: [
        InkWell(
          onTap: _handleTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.lightGray.withOpacity(0.5)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _isLocked
                        ? AppColors.lightGray.withOpacity(0.5)
                        : hasVideo
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.colorFF6905.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _isLocked
                        ? Icons.lock
                        : hasVideo
                            ? Icons.play_circle_outline
                            : Icons.description_outlined,
                    size: 20,
                    color: _isLocked
                        ? AppColors.color8F959E
                        : hasVideo
                            ? AppColors.primary
                            : AppColors.colorFF6905,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.content.title ?? '',
                        style: AppTextStyles.textContent2.copyWith(
                          color: _isLocked ? AppColors.color8F959E : AppColors.text,
                          fontWeight: hasVideo ? FontWeight.w500 : FontWeight.normal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (hasDescription && !_isExpanded) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.content.description ?? '',
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
                if (_isLocked)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.lightGray.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'course.locked'.tr(),
                      style: AppTextStyles.textContent4.copyWith(
                        color: AppColors.color8F959E,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else if (hasVideo)
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 20,
                  )
                else
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.colorFF6905,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
        if (_isExpanded && hasDescription && !hasVideo)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(68, 0, 16, 12),
            child: Text(
              widget.content.description ?? '',
              style: AppTextStyles.textContent3.copyWith(
                color: AppColors.color8F959E,
                height: 1.5,
              ),
            ),
          ),
      ],
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
