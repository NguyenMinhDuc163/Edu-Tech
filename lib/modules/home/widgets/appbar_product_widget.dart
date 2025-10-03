import 'package:ed_tech/modules/home/screen/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../init.dart';
import '../../../core/widgets/drawer_widget.dart';

class AppbarProductWidget extends StatelessWidget {
  const AppbarProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppPad.h16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.white,
              child: IconButton(
                icon: SvgPicture.asset(IconPath.iconMenu),
                onPressed: () => _openOverlayDrawer(context),
              ),
            ),
            CircleAvatar(
              backgroundColor: AppColors.white,
              child: IconButton(
                icon: SvgPicture.asset(IconPath.iconBag),
                onPressed:
                    () => Navigator.pushNamed(context, HomeScreen.routeName),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openOverlayDrawer(BuildContext context) {
    final double panelWidth = MediaQuery.of(context).size.width * 0.8;
    showGeneralDialog(
      context: context,
      barrierLabel: 'overlay-drawer',
      barrierDismissible: true,
      barrierColor: AppColors.barrier,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: panelWidth,
              height: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: const DrawerWidget(),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offset = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return SlideTransition(position: offset, child: child);
      },
    );
  }
}
