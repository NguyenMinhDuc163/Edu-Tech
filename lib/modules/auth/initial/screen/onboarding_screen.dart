import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/core/widgets/template/button_widget.dart';
import 'package:ed_tech/modules/dashboard/screen/dashboard_screen.dart';
import 'package:ed_tech/init.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  static const String routeName = '/onboardingScreen';
  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      isShowAppBar: false,
      isShowBottomButton: false,
      screen: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: AppPad.h22v10,
            child: _cardWidget(
              context: context,
              onMen: () => Navigator.pushNamed(context, DashboardScreen.routeName),
              onWomen: () => Navigator.pushNamed(context, DashboardScreen.routeName),
              onSkip: () => Navigator.pushNamed(context, DashboardScreen.routeName),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardWidget({
    required BuildContext context,
    required VoidCallback onWomen,
    required VoidCallback onMen,
    required VoidCallback onSkip,
  }) {
    return Container(
      padding: AppPad.a20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.a14,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        spacing: height_16,
        children: [
          Text(
            'onboarding.slogan'.tr(),
            style: AppTextStyles.textHeader3,
            textAlign: TextAlign.center,
          ),
          Text(
            'onboarding.description'.tr(),
            style: AppTextStyles.textContent2.copyWith(
              color: AppColors.coolGray,
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            spacing: width_16,
            children: [
              Expanded(
                child: ButtonWidget(
                  title: "onboarding.women".tr(),
                  padding: AppPad.v14,
                  boderRadius: AppBorderRadius.a14,
                  backgroundColor: AppColors.lightGray,
                  titleStyle: AppTextStyles.textContent1.copyWith(
                    color: AppColors.coolGray,
                  ),
                  onPressed: onWomen,
                ),
              ),
              Expanded(
                child: ButtonWidget(
                  title: "onboarding.men".tr(),
                  padding: AppPad.v14,
                  boderRadius: AppBorderRadius.a14,
                  titleStyle: AppTextStyles.textContent1.copyWith(
                    color: AppColors.white,
                  ),
                  onPressed: onMen,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onSkip,
            child: Text(
              'onboarding.skip'.tr(),
              style: AppTextStyles.textContent1.copyWith(
                color: AppColors.coolGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
