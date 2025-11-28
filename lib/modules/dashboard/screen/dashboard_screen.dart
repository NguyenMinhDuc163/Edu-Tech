import 'package:disposable_provider/disposable_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/core/constants/icon_path.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
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
import 'package:ed_tech/modules/message/bloc/chatbot_cubit.dart';
import 'package:ed_tech/modules/message/repository/chat_bot_repo.dart';
import 'package:ed_tech/modules/message/screen/chat_bot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/dashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

// Danh sách route names để sử dụng trong navigation
final List<String> _tabRoutes = [
  HomeScreen.routeName,
  CourseScreen.routeName,
  ChatBotScreen.routeName,
  QuizListScreen.routeName,
];

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

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
            create: (context) => FilterCourseCubit(repo: context.read<SearchCourseRepo>()),
          ),
        ],
        child: DisposableProvider(
          create: (_) => CourseController(),
          child: const CourseScreen(),
        ),
      ),
    ),
    RepositoryProvider(
      create: (context) => ChatBotRepo(apiClient: ApiClient()),
      child: BlocProvider(
        create: (context) => ChatbotCubit(repo: context.read<ChatBotRepo>()),
        child: DisposableProvider(
          create: (_) => ChatController(),
          child: ChatBotScreen(),
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
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              print('====>: ${_tabRoutes[index]}');
            },
            items: [
              SalomonBottomBarItem(
                icon: SvgPicture.asset(
                  IconPath.iconHome,
                  width: 25,
                  height: 25,
                  color: AppColors.color8F959E,
                ),
                title: Text("home_screen.home".tr()),
                activeIcon: SizedBox.shrink(),
              ),
              SalomonBottomBarItem(
                icon: SvgPicture.asset(
                  IconPath.iconBook,
                  width: 25,
                  height: 25,
                  color: AppColors.color8F959E,
                ),
                title: Text("home_screen.course".tr()),
                activeIcon: SizedBox.shrink(),
              ),
              SalomonBottomBarItem(
                icon: SvgPicture.asset(
                  IconPath.iconChat,
                  width: 25,
                  height: 25,
                  color: AppColors.color8F959E,
                ),
                title: Text("home_screen.message".tr()),
                activeIcon: SizedBox.shrink(),
              ),
              SalomonBottomBarItem(
                icon: SvgPicture.asset(
                  IconPath.iconAssigment,
                  width: 25,
                  height: 25,
                  color: AppColors.color8F959E,
                ),
                title: Text("Exam".tr()),
                activeIcon: SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
