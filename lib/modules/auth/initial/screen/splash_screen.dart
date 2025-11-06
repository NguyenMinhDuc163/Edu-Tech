import 'package:ed_tech/modules/auth/initial/screen/onboarding_screen.dart';
import 'package:ed_tech/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:ed_tech/modules/dashboard/screen/dashboard_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/auth/sign_in/repository/sign_in_repo.dart';
import 'package:ed_tech/common/app_status.dart';
import 'package:ed_tech/common/app_event_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/splash_screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirectIntroScreen();
  }

  void redirectIntroScreen() async {
    await AppStatus.ensureInitialized();

    if (!mounted) return;

    final isFirstTime = AppStatus.isFirstTimeAppLaunch;
    AppEventService.notifyAppLaunch();

    if (isFirstTime) {
      Navigator.pushNamed(context, OnboardingScreen.routeName);
    } else {
      Navigator.of(context).pushNamed(SignInScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: AppColors.skyBlue)),
        Center(
          child: Image.asset(
            IconPath.appIcon,
            width: 150,
            height: 150,
          ),
        ),
      ],
    );
  }
}
