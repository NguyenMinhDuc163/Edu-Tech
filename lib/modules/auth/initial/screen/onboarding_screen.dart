import 'package:ed_tech/init.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/common/widgets/images/custom_asset_svg_picture.dart';
import 'package:ed_tech/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:ed_tech/modules/auth/sign_up/screen/sign_up_screen.dart';
import 'package:ed_tech/modules/dashboard/screen/dashboard_screen.dart';
import 'package:ed_tech/common/app_event_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  static const String routeName = '/onboardingScreen';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardData> _pages = const [
    _OnboardData(
      titleKey: 'onboarding.trial_courses',
      descriptionKey: 'onboarding.free_courses',
      asset: ImagePath.introStep1,
    ),
    _OnboardData(
      titleKey: 'onboarding.quick_learning',
      descriptionKey: 'onboarding.flexible_learning',
      asset: ImagePath.introStep2,
    ),
    _OnboardData(
      titleKey: 'onboarding.create_study_plan',
      descriptionKey: 'onboarding.study_with_plan',
      asset: ImagePath.introStep3,
    ),
  ];

  void _onSkip() {
    AppEventService.notifyUserStartExperience();
    Navigator.pushReplacementNamed(context, SignInScreen.routeName);
  }

  void _onNavigateToSignIn({String type = "SI"}) {
    AppEventService.notifyUserStartExperience();
    if(type == 'SI'){
      Navigator.pushNamed(context, SignInScreen.routeName);
    }else{
      Navigator.pushNamed(context, SignUpScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      isShowAppBar: false,
      isShowBottomButton: false,
      screen: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child:
                  _currentIndex == _pages.length - 1
                      ? const SizedBox.shrink()
                      : TextButton(
                        onPressed: _onSkip,
                        child: Text('onboarding.skip'.tr()),
                      ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return _OnboardItem(data: data);
                },
              ),
            ),
            const SizedBox(height: 12),
            _DotsIndicator(count: _pages.length, index: _currentIndex),
            const SizedBox(height: 24),
            if (_currentIndex == _pages.length - 1)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                      ),
                      onPressed: () => _onNavigateToSignIn(type: "SI"),
                      child: Text('onboarding.log_in'.tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      onPressed: () => _onNavigateToSignIn(type: "SU"),
                      child: Text('onboarding.sign_up'.tr()),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OnboardData {
  final String titleKey;
  final String descriptionKey;
  final String asset;
  const _OnboardData({
    required this.titleKey,
    required this.descriptionKey,
    required this.asset,
  });
}

class _OnboardItem extends StatelessWidget {
  const _OnboardItem({required this.data});
  final _OnboardData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.all(AppRadius.c24),
          ),
          child: CustomAssetSvgPicture(
            data.asset,
            width: 220,
            height: 220,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          data.titleKey.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.textHeader3,
        ),
        const SizedBox(height: 12),
        Text(
          data.descriptionKey.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.textContent3,
        ),
      ],
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final bool isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 20 : 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
