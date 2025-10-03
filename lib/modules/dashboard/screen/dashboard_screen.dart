import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/modules/course/screen/course_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:ed_tech/core/constants/icon_path.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/widgets/drawer_widget.dart';
import 'package:ed_tech/modules/dashboard/model/tab_item.dart';
import 'package:ed_tech/modules/home/screen/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/dashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

final List<TabItem> _tabs = [
  TabItem(widget: HomeScreen(), route: HomeScreen.routeName),
  TabItem(widget: CourseScreen(), route: CourseScreen.routeName),
  TabItem(widget: HomeScreen(), route: HomeScreen.routeName),
  TabItem(widget: HomeScreen(), route: HomeScreen.routeName),
];

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
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
          body: IndexedStack(
            index: _currentIndex,
            children: _tabs.map((tab) => tab.widget).toList(),
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            selectedColorOpacity: 0.0,
            backgroundColor: Colors.transparent,
            duration: Duration.zero,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              print('====>: ${_tabs[index].route}');
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
                  IconPath.iconSetting,
                  width: 25,
                  height: 25,
                  color: AppColors.color8F959E,
                ),
                title: Text("home_screen.account".tr()),
                activeIcon: SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
