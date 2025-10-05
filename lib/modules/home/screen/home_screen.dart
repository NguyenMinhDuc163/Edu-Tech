import 'package:flutter_svg/flutter_svg.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/home/widgets/home_header.dart';
import 'package:ed_tech/modules/home/widgets/home_promo_carousel.dart';
import 'package:ed_tech/modules/home/widgets/learning_plan_widget.dart';
import 'package:ed_tech/modules/home/widgets/course_suggestions_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();
  static const String routeName = '/HomeScreen';
  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      isShowBottomButton: false,
      isShowAppBar: true,
      isShowDrawer: true,
      appbarColor:  AppColors.primary,
      actionsWidget: [
        GestureDetector(
          onTap: () => {},
          child: SvgPicture.asset(IconPath.iconBag, color: AppColors.black50, width: 20, height: 20,),
        ),
      ],
      screen: SingleChildScrollView(
        child: Column(
          children: [
            const HomeHeaderWidget(),
            SizedBox(height: 70),
            Padding(padding: AppPad.h16, child: HomePromoCarousel()),
            const SizedBox(height: 25),
            const LearningPlanWidget(),
            const SizedBox(height: 16),
            const CourseSuggestionsWidget(),
          ],
        ),
      ),
    );
  }
}
