import 'package:disposable_provider/disposable_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/core/constants/icon_path.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/widgets/drawer_widget.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/modules/assessment/bloc/list_quiz_controller.dart';
import 'package:ed_tech/modules/assessment/bloc/list_quiz_cubit.dart';
import 'package:ed_tech/modules/assessment/repository/quiz_repo.dart';
import 'package:ed_tech/modules/assessment/screen/quiz_list_screen.dart';
import 'package:ed_tech/modules/course/bloc/course_controller.dart';
import 'package:ed_tech/modules/course/bloc/course_cubit.dart';
import 'package:ed_tech/modules/course/bloc/filter_course_cubit.dart';
import 'package:ed_tech/modules/course/repository/course_repo.dart';
import 'package:ed_tech/modules/course/repository/search_course_repo.dart';
import 'package:ed_tech/modules/course/screen/course_screen.dart';
import 'package:ed_tech/modules/home/bloc/home_controller.dart';
import 'package:ed_tech/modules/home/bloc/home_cubit.dart';
import 'package:ed_tech/modules/home/repository/home_repo.dart';
import 'package:ed_tech/modules/home/screen/home_screen.dart';
import 'package:ed_tech/modules/message/bloc/chat_controller.dart';
import 'package:ed_tech/modules/message/bloc/chat_history_cubit.dart';
import 'package:ed_tech/modules/message/bloc/chatbot_cubit.dart';
import 'package:ed_tech/modules/message/repository/chat_bot_repo.dart';
import 'package:ed_tech/modules/message/repository/chat_sessions_repo.dart';
import 'package:ed_tech/modules/message/screen/chat_bot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sp_util/sp_util.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/dashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const int _homeTabIndex = 0;
  static const int _chatBotTabIndex = 2;
  static const String _aiDataConsentKey = 'ai_chat_data_consent_accepted';

  int _currentIndex = 0;
  bool _isShowingAiConsentDialog = false;

  List<Widget> get _tabWidgets => [
    RepositoryProvider(
      create: (context) => HomeRepo(apiClient: ApiClient()),
      child: BlocProvider(
        create: (context) => HomeCubit(repo: context.read<HomeRepo>()),
        child: DisposableProvider(
          create: (_) => HomeController(),
          child: HomeScreen(
            onNavigateToQuizTab: () {
              setState(() {
                _currentIndex = 3;
              });
            },
            onNavigateToCourseTab: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
        ),
      ),
    ),
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CourseRepo(apiClient: ApiClient()),
        ),
        RepositoryProvider(
          create: (context) => SearchCourseRepo(apiClient: ApiClient()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CourseCubit(repo: context.read<CourseRepo>()),
          ),
          BlocProvider(
            create:
                (context) =>
                    FilterCourseCubit(repo: context.read<SearchCourseRepo>()),
          ),
        ],
        child: DisposableProvider(
          create: (_) => CourseController(),
          child: const CourseScreen(),
        ),
      ),
    ),
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ChatBotRepo(apiClient: ApiClient()),
        ),
        RepositoryProvider(
          create: (context) => ChatSessionsRepo(apiClient: ApiClient()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => ChatbotCubit(repo: context.read<ChatBotRepo>()),
          ),
          BlocProvider(
            create:
                (context) =>
                    ChatHistoryCubit(repo: context.read<ChatSessionsRepo>()),
          ),
        ],
        child: DisposableProvider(
          create: (_) => ChatController(),
          child: const ChatBotScreen(),
        ),
      ),
    ),
    RepositoryProvider(
      create: (context) => QuizRepo(apiClient: ApiClient()),
      child: BlocProvider(
        create: (context) => ListQuizCubit(repo: context.read<QuizRepo>()),
        child: DisposableProvider(
          create: (_) => ListQuizController(),
          child: QuizListScreen(),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: AppColors.white,
          systemNavigationBarContrastEnforced: false,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: DrawerWidget(),
          body: IndexedStack(index: _currentIndex, children: _tabWidgets),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            selectedColorOpacity: 0.0,
            backgroundColor: Colors.transparent,
            duration: Duration.zero,
            onTap: (index) async {
              if (index == _chatBotTabIndex &&
                  !(SpUtil.getBool(_aiDataConsentKey) ?? false)) {
                final accepted = await _showAiDataConsentDialog();
                if (!mounted) return;

                if (!accepted) {
                  setState(() {
                    _currentIndex = _homeTabIndex;
                  });
                  return;
                }
              }

              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              SalomonBottomBarItem(
                icon: SvgPicture.asset(
                  IconPath.iconHome,
                  width: 25,
                  height: 25,
                  colorFilter: const ColorFilter.mode(
                    AppColors.color8F959E,
                    BlendMode.srcIn,
                  ),
                ),
                title: Text("home_screen.home".tr()),
                activeIcon: SizedBox.shrink(),
              ),
              SalomonBottomBarItem(
                icon: SvgPicture.asset(
                  IconPath.iconBook,
                  width: 25,
                  height: 25,
                  colorFilter: const ColorFilter.mode(
                    AppColors.color8F959E,
                    BlendMode.srcIn,
                  ),
                ),
                title: Text("home_screen.course".tr()),
                activeIcon: SizedBox.shrink(),
              ),
              SalomonBottomBarItem(
                icon: SvgPicture.asset(
                  IconPath.iconChat,
                  width: 25,
                  height: 25,
                  colorFilter: const ColorFilter.mode(
                    AppColors.color8F959E,
                    BlendMode.srcIn,
                  ),
                ),
                title: Text("home_screen.message".tr()),
                activeIcon: SizedBox.shrink(),
              ),
              SalomonBottomBarItem(
                icon: SvgPicture.asset(
                  IconPath.iconAssigment,
                  width: 25,
                  height: 25,
                  colorFilter: const ColorFilter.mode(
                    AppColors.color8F959E,
                    BlendMode.srcIn,
                  ),
                ),
                title: Text("assessment.exam".tr()),
                activeIcon: SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showAiDataConsentDialog() async {
    if (_isShowingAiConsentDialog) return false;
    _isShowingAiConsentDialog = true;

    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'chat.ai_consent_title'.tr(),
              style: AppTextStyles.textStyleDefaultBold,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAiConsentText('chat.ai_consent_description'),
                  _buildAiConsentText('chat.ai_consent_data_sent'),
                  _buildAiConsentText('chat.ai_consent_sent_to'),
                  _buildAiConsentText('chat.ai_consent_purpose'),
                  _buildAiConsentText('chat.ai_consent_privacy_notice'),
                  _buildAiConsentText('chat.ai_consent_permission'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(
                  'chat.ai_consent_cancel'.tr(),
                  style: AppTextStyles.textButton.copyWith(
                    color: AppColors.coolGray,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await SpUtil.putBool(_aiDataConsentKey, true);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                child: Text(
                  'chat.ai_consent_confirm'.tr(),
                  style: AppTextStyles.button,
                ),
              ),
            ],
          ),
    );

    _isShowingAiConsentDialog = false;
    return accepted ?? false;
  }

  Widget _buildAiConsentText(String translationKey) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(translationKey.tr(), style: AppTextStyles.textContent2),
    );
  }
}
