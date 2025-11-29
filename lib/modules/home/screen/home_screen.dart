import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/home/bloc/home_controller.dart';
import 'package:ed_tech/modules/home/bloc/home_cubit.dart';
import 'package:ed_tech/modules/home/widgets/home_header.dart';
import 'package:ed_tech/modules/home/widgets/home_promo_carousel.dart';
import 'package:ed_tech/modules/home/widgets/learning_plan_widget.dart';
import 'package:ed_tech/modules/home/widgets/course_suggestions_widget.dart';
import 'package:ed_tech/modules/purchased_courses/screen/purchased_courses_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToQuizTab;

  const HomeScreen({this.onNavigateToQuizTab});
  static const String routeName = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = DisposableProvider.of<HomeController>(
      context,
    );

    return FunctionScreenTemplate(
      isShowBottomButton: false,
      isShowAppBar: true,
      isShowDrawer: true,
      appbarColor: AppColors.primary,
      actionsWidget: [
        ValueListenableBuilder<bool>(
          valueListenable: controller.isSearchVisible,
          builder: (context, isSearchVisible, child) {
            return ClipRect(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSearchVisible) ...[
                    Container(
                      width: 110,
                      child: TextField(
                        onChanged: controller.updateSearchQuery,
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          isDense: true,
                        ),
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 3),
                  ],

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PurchasedCoursesScreen.routeName,
                      );
                    },
                    child: SvgPicture.asset(
                      IconPath.iconBag,
                      color: AppColors.black50,
                      width: 18,
                      height: 18,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      screen: SingleChildScrollView(
        child: Column(
          children: [
            const HomeHeaderWidget(),
            SizedBox(height: 70),
            Padding(padding: AppPad.h16, child: HomePromoCarousel()),
            const SizedBox(height: 25),
            LearningPlanWidget(onNavigateToQuizTab: widget.onNavigateToQuizTab),
            const SizedBox(height: 16),
            const CourseSuggestionsWidget(),
          ],
        ),
      ),
    );
  }
}
