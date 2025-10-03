import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/modules/course/screen/course_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/public/global_utils.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/widgets/template/function_screen_template.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/forgot_pass_controller.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/forgot_pass_cubit.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/reset_pass_controller.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/reset_pass_cubit.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/verify_otp_controller.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/verify_otp_cubit.dart';
import 'package:ed_tech/modules/auth/forgot_password/repository/forgot_pass_repo.dart';
import 'package:ed_tech/modules/auth/forgot_password/screen/forgot_password_screen.dart';
import 'package:ed_tech/modules/auth/forgot_password/screen/reset_password_screen.dart';
import 'package:ed_tech/modules/auth/forgot_password/screen/verify_screen.dart';
import 'package:ed_tech/modules/auth/initial/screen/onboarding_screen.dart';
import 'package:ed_tech/modules/auth/initial/screen/splash_screen.dart';
import 'package:ed_tech/modules/auth/login/bloc/login_controller.dart';
import 'package:ed_tech/modules/auth/login/screen/login_screen.dart';
import 'package:ed_tech/modules/auth/sign_in/bloc/sign_in_controller.dart';
import 'package:ed_tech/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:ed_tech/modules/auth/sign_up/bloc/sign_up_controller.dart';
import 'package:ed_tech/modules/auth/sign_up/bloc/sign_up_cubit.dart';
import 'package:ed_tech/modules/auth/sign_up/repository/sign_up_repo.dart';
import 'package:ed_tech/modules/auth/sign_up/screen/sign_up_screen.dart';
import 'package:ed_tech/modules/dashboard/screen/dashboard_screen.dart';
import 'package:ed_tech/modules/home/bloc/home_cubit.dart';
import 'package:ed_tech/modules/home/repository/home_repo.dart';
import 'package:ed_tech/modules/home/screen/home_screen.dart';

//part of in dart
class Routers {
  static Map<String, WidgetBuilder> routes = {
    OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    GlobalUtils.ROUTES = settings.name;
    // TODO Task 1: hiển thị log khi chuyển màn

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(settings: settings, builder: (_) => const SplashScreen());
      case HomeScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => RepositoryProvider(
            create: (context) => HomeRepo(apiClient: ApiClient()),
            child: BlocProvider(
              create: (context) => HomeCubit(repo: context.read<HomeRepo>()),
              child: HomeScreen(),
            ),
          ),
        );
      case DashboardScreen.routeName:
        return MaterialPageRoute(settings: settings, builder: (_) => DashboardScreen());
      case LoginScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => DisposableProvider(
            create: (BuildContext context) {
              return LoginController();
            },
            child: LoginScreen(),
          ),
        );
      case SignUpScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => RepositoryProvider(
            create: (context) => SignUpRepo(apiClient: ApiClient()),
            child: BlocProvider(
              create: (context) => SignUpCubit(repo: context.read<SignUpRepo>()),
              child: DisposableProvider(
                create: (BuildContext context) {
                  return SignUpController();
                },
                child: SignUpScreen(),
              ),
            ),
          ),
        );
      case SignInScreen.routeName:
        final Map<String, String>? prefillData = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => DisposableProvider(
            create: (BuildContext context) {
              return SignInController(prefillData: prefillData);
            },
            child: SignInScreen(),
          ),
        );
      case ForgotPasswordScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => RepositoryProvider(
            create: (context) => ForgotPassRepo(apiClient: ApiClient()),
            child: BlocProvider(
              create: (context) => ForgotPassCubit(repo: context.read<ForgotPassRepo>()),
              child: DisposableProvider(
                create: (BuildContext context) {
                  return ForgotPassController();
                },
                child: ForgotPasswordScreen(),
              ),
            ),
          ),
        );

      case VerifyScreen.routeName:
        final Map<String, String>? data = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => RepositoryProvider(
            create: (context) => ForgotPassRepo(apiClient: ApiClient()),

            child: BlocProvider(
              create: (context) => VerifyOtpCubit(repo: context.read<ForgotPassRepo>()),

              child: DisposableProvider(
                create: (BuildContext context) {
                  return VerifyOtpController(dataUser: data);
                },
                child: VerifyScreen(),
              ),
            ),
          ),
        );

      case ResetPasswordScreen.routeName:
        final Map<String, String>? data = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => RepositoryProvider(
            create: (context) => ForgotPassRepo(apiClient: ApiClient()),

            child: BlocProvider(
              create: (context) => ResetPassCubit(repo: context.read<ForgotPassRepo>()),

              child: DisposableProvider(
                create: (BuildContext context) {
                  return ResetPassController(dataUser: data);
                },
                child: ResetPasswordScreen(),
              ),
            ),
          ),
        );

      case CourseScreen.routeName:
        return MaterialPageRoute(settings: settings, builder: (_) => CourseScreen());
      default:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => FunctionScreenTemplate(
            title: "Chức năng đang trong quá trình phát triển",
            isShowBottomButton: false,
            screen: Center(
              child: Text(
                "Chức năng đang trong quá trình phát triển",
                style: AppTextStyles.text,
              ),
            ),
          ),
        );
    }
  }
}
