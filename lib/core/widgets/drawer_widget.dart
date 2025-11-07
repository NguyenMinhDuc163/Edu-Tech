import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ed_tech/core/widgets/switch_botton_widget.dart';
import 'package:ed_tech/core/widgets/template/button_widget.dart';
import 'package:ed_tech/core/theme/locale_cubit.dart';
import 'package:ed_tech/core/theme/theme_cubit.dart';
import 'package:ed_tech/core/theme/theme_extensions.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/auth/login/screen/login_screen.dart';
import 'package:ed_tech/modules/auth/sign_in/repository/sign_in_repo.dart';
import 'package:ed_tech/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:ed_tech/common/app_event_service.dart';
import 'package:ed_tech/data/services/user_service.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: AppPad.v40,
          children: <Widget>[
            Padding(
              padding: AppPad.h20,
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: AppColors.offWhite,
                    child: SvgPicture.asset(IconPath.iconMenu),
                  ),
                ),
              ),
            ),

            Container(
              padding: AppPad.a20,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: _buildDrawerHeader(),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDrawerItem(
                    icon: IconPath.iconSun,
                    title: 'common.dark_mode'.tr(),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                Padding(
                  padding: AppPad.h10,
                  child: SwitchBottomWidget(
                    onChanged: (value) {
                      final newThemeMode = value ? ThemeMode.dark : ThemeMode.light;
                      context.read<ThemeCubit>().setThemeMode(newThemeMode);
                    },
                  ),
                ),
              ],
            ),
            // Language switcher
            Row(
              children: [
                Expanded(
                  child: _buildDrawerItem(
                    icon: IconPath.iconAssigment,
                    title: 'common.language'.tr(),
                    onTap: () {}, // Không làm gì - chỉ để hiển thị label
                  ),
                ),
                Padding(
                  padding: AppPad.h10,
                  child: BlocBuilder<LocaleCubit, Locale>(
                    builder: (context, locale) {
                      final isEnglish = locale.languageCode == 'en';
                      return GestureDetector(
                        onTap: () {
                          final localeCubit = context.read<LocaleCubit>();
                          localeCubit.toggleLocale(context);
                        },
                        child: Container(
                          padding: AppPad.a8,
                          decoration: BoxDecoration(
                            color: AppColors.offWhite,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isEnglish ? 'EN' : 'VI',
                            style: AppTextStyles.textContent3.copyWith(
                              color: AppColors.coolGray,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            _buildDrawerItem(
              icon: IconPath.iconLogout,
              title: 'common.logout'.tr(),
              iconColor: Colors.red,
              textStyle: AppTextStyles.textContent2.copyWith(color: Colors.red),
              onTap: () async {
                final navigator = Navigator.of(context);

                context.read<SignInRepo>().logout();
                await AppEventService.notifyUserSignOut();

                navigator.pushReplacementNamed(SignInScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    final username = UserService.instance.displayName;
    final email = UserService.instance.email;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: width_8,
          children: [
            CircleAvatar(radius: 25, backgroundColor: Colors.grey[200], child: Icon(Icons.person)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: AppTextStyles.textHeader3),
                  if (email.isNotEmpty)
                    Text(
                      email,
                      style: AppTextStyles.textContent3.copyWith(color: AppColors.coolGray),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            ButtonWidget(
              title: "common.orders".tr(),
              boderRadius: AppBorderRadius.a8,
              padding: AppPad.h10v8,
              backgroundColor: AppColors.offWhite,
              titleStyle: AppTextStyles.textContent3.copyWith(color: AppColors.coolGray),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    TextStyle? textStyle,
    Color? iconColor,
  }) {
    return ListTile(
      leading: SvgPicture.asset(icon, color: iconColor ?? Colors.grey[700]),
      title: Text(title, style: textStyle ?? AppTextStyles.textContent2),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      dense: true,
    );
  }
}
