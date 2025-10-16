import 'package:ed_tech/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:ed_tech/modules/dashboard/screen/dashboard_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/auth/login/screen/login_screen.dart';
import 'package:ed_tech/modules/auth/sign_in/repository/sign_in_repo.dart';
import 'package:ed_tech/modules/home/screen/home_screen.dart';

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
    String? token = context.read<SignInRepo>().authService.accessToken;
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    if(token != null) {
      Navigator.of(context).pushNamed(DashboardScreen.routeName);
    }else{
      Navigator.of(context).pushNamed(SignInScreen.routeName);

    }

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: AppColors.lavenderColor)),
        // Center(
        //   child: Column(
        //     spacing: 10,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       // Image.asset(ImagePath.imgSplash),
        //       // Image.asset(ImagePath.imgTitleSplash),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
