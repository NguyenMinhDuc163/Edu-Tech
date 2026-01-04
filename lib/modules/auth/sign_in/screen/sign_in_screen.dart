import 'package:disposable_provider/disposable_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/core/values/login_type.dart';
import 'package:ed_tech/core/widgets/template/button_widget.dart';
import 'package:ed_tech/modules/auth/login/widget/title_widget.dart';
import 'package:ed_tech/modules/auth/sign_up/screen/sign_up_screen.dart';
import 'package:ed_tech/modules/dashboard/screen/dashboard_screen.dart';
import 'package:ed_tech/modules/home/screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/widgets/app_gap.dart';
import 'package:ed_tech/core/widgets/switch_botton_widget.dart';
import 'package:ed_tech/core/widgets/text_input_custom.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/auth/forgot_password/screen/forgot_password_screen.dart';
import 'package:ed_tech/modules/auth/forgot_password/screen/reset_password_screen.dart';
import 'package:ed_tech/modules/auth/sign_in/bloc/sign_in_controller.dart';
import 'package:ed_tech/modules/auth/sign_in/bloc/sign_in_cubit.dart';
import 'package:ed_tech/modules/auth/sign_in/bloc/sign_in_state.dart';
import 'package:ed_tech/modules/auth/sign_in/repository/sign_in_repo.dart';
import 'package:ed_tech/modules/auth/widgets/text_span_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  static const String routeName = '/signInScreen';

  @override
  Widget build(BuildContext context) {
    final SignInController controller = DisposableProvider.of<SignInController>(context);
    return BlocListener<SignInCubit, SignInState>(
      listener: controller.handleListener,
      child: _SignInContent(controller: controller),
    );
  }
}

class _SignInContent extends StatelessWidget {
  const _SignInContent({required this.controller});

  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    final SignInState state = context.watch<SignInCubit>().state;

    final Widget contentWidget = Padding(
      padding: AppPad.h22v10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppGap.h50,
            Text("login.welcome".tr(), style: AppTextStyles.textHeader1),
            Text(
              "login.enter_data_to_continue".tr(),
              style: AppTextStyles.textContent1.copyWith(color: AppColors.coolGray),
            ),
            AppGap.h50,
            TextInputCustom(
              label: 'sign_up.username'.tr(),
              controller: controller.usernameController,
              hintText: "sign_up.enter_username".tr(),
              borderRadius: BorderRadius.circular(12),
              validator: (text) {
                return text.length >= 4;
              },
            ),
            AppGap.h30,
            TextInputCustom(
              label: 'sign_up.password'.tr(),
              controller: controller.passwordController,
              hintText: "sign_up.enter_password".tr(),
              borderRadius: BorderRadius.circular(12),
              isLineBottom: false,
              isPassword: true,
              suffixIcon: Text(
                "sign_up.strong".tr(),
                style: AppTextStyles.textContent3.copyWith(color: AppColors.limeGreen),
              ),
              validator: (text) {
                return text.length >= 8;
              },
            ),
            AppGap.h30,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: controller.rememberMe,
                  builder: (context, value, child) {
                    return Checkbox(
                      value: value,
                      onChanged: (newValue) {
                        controller.rememberMe.value = newValue ?? true;
                      },
                    );
                  },
                ),
                Text("sign_up.remember_me".tr(), style: AppTextStyles.textContent2),
                Spacer(),
                GestureDetector(
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        ForgotPasswordScreen.routeName,
                        // ResetPasswordScreen.routeName,
                      ),
                  child: Text(
                    "login.forgot_password".tr(),
                    style: AppTextStyles.textContent1.copyWith(color: Colors.red),
                  ),
                ),
              ],
            ),
            AppGap.h20,
            ButtonWidget(
              title: "login.title".tr(),
              backgroundColor: AppColors.primary,
              padding: AppPad.v14,
              boderRadius: BorderRadius.all(AppRadius.c16),
              onPressed: () {
                controller.onSignIn(context);
              },
            ),
            AppGap.h10,
            TextSpanWidget(
              normalText: "${'login_screen.no_account_question'.tr()} ",
              clickableText: 'sign_up.title'.tr(),
              onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
              clickableTextStyle: TextStyle(color: AppColors.electricBlue),
            ),
            
            // Row(
            //   children: [
            //     Expanded(child: Divider(color: AppColors.divider)),
            //     Padding(
            //       padding: AppPad.h20v10,
            //       child: Text(
            //         "login.or_login_with".tr(),
            //         style: AppTextStyles.textContent2.copyWith(color: AppColors.coolGray),
            //       ),
            //     ),
            //     Expanded(child: Divider(color: AppColors.divider)),
            //   ],
            // ),
            // AppGap.h10,
            // ButtonWidget(
            //   titleWidget: TitleWidget(
            //     title: "login.google".tr(),
            //     iconPath: IconPath.iconGoogle,
            //   ),
            //   onPressed: () {
            //     // controller.onLogin(context, LoginType.google);
            //   },
            //   backgroundColor: AppColors.crimson,
            //   padding: AppPad.v14,
            //   boderRadius: BorderRadius.all(AppRadius.c16),
            // ),
          ],
        ),
      ),
    );

    return Stack(
      children: [
        FunctionScreenTemplate(
          isShowBottomButton: false,
          isShowAppBar: false,
          screen: contentWidget,
        ),
        if (state is SignInInProgress)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
