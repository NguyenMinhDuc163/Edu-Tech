import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/core/widgets/template/button_widget.dart';
import 'package:ed_tech/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:ed_tech/modules/auth/widgets/text_span_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/widgets/app_gap.dart';
import 'package:ed_tech/core/widgets/switch_botton_widget.dart';
import 'package:ed_tech/core/widgets/text_input_custom.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/auth/sign_up/bloc/sign_up_controller.dart';
import 'package:ed_tech/modules/auth/sign_up/bloc/sign_up_cubit.dart';
import 'package:ed_tech/modules/auth/sign_up/bloc/sign_up_state.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  static const String routeName = '/signUpScreen';
  @override
  Widget build(BuildContext context) {
    final SignUpController controller = context.read();

    return BlocListener<SignUpCubit, SignUpState>(
      listener: controller.handleListener,
      listenWhen: (previous, next) => previous.runtimeType != next.runtimeType,
      child: _SignUpContent(controller: controller),
    );
  }
}

class _SignUpContent extends StatelessWidget {
  const _SignUpContent({required this.controller});

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    final SignUpState state = context.watch<SignUpCubit>().state;

    final Widget contentWidget = Center(
      child: Padding(
        padding: AppPad.h22v10,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            spacing: 20,
            children: [
              Text('sign_up.title'.tr(), style: AppTextStyles.textHeader1),
              AppGap.h10,
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (previous, current) {
                  return current is CheckUsernameInProgress ||
                      current is CheckUsernameSuccess ||
                      current is CheckUsernameFailure;
                },
                builder: (context, state) {
                  return TextInputCustom(
                    label: 'sign_up.username'.tr(),
                    controller: controller.usernameController,
                    hintText: "sign_up.enter_username".tr(),
                    borderRadius: BorderRadius.circular(12),
                    validator: (text) {
                      // if (state is CheckUsernameSuccess) {
                      //   return state.isAvailable;
                      // }
                      // return false;
                      return text.length > 4;

                    },
                    // onChanged: (text) => context.read<SignUpCubit>().onUsernameChanged(text),
                  );
                },
              ),
              TextInputCustom(
                label: 'sign_up.password'.tr(),
                controller: controller.passwordController,
                hintText: "sign_up.enter_password".tr(),
                borderRadius: BorderRadius.circular(12),
                isPassword: true,
                suffixIcon: Text(
                  "sign_up.strong".tr(),
                  style: AppTextStyles.textContent3.copyWith(color: AppColors.limeGreen),
                ),
                validator: (text) {
                  return text.length >= 8;
                },
              ),
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (previous, current) {
                  return current is CheckEmailInProgress ||
                      current is CheckEmailSuccess ||
                      current is CheckEmailFailure;
                },
                builder: (context, state) {
                  return TextInputCustom(
                    label: 'sign_up.email'.tr(),
                    controller: controller.emailController,
                    hintText: "sign_up.enter_email".tr(),
                    borderRadius: BorderRadius.circular(12),
                    validator: (text) {
                      // if (state is CheckEmailSuccess) {
                      //   return state.isAvailable;
                      // }
                      // return false;
                     return text.length > 4;
                    },
                    // onChanged: (text) => context.read<SignUpCubit>().onEmailChanged(text),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("sign_up.remember_me".tr(), style: AppTextStyles.textContent3),
                  SwitchBottomWidget(onChanged: (value) {}),
                ],
              ),

              ButtonWidget(
                title: "sign_up.title".tr(),
                backgroundColor: AppColors.primary,
                padding: AppPad.v14,
                boderRadius: BorderRadius.all(AppRadius.c16),
                onPressed: () {
                  controller.onSignUp(context);
                },
              ),

              TextSpanWidget(
                normalText: "${'login.connect_account_confirmation'.tr()} ",
                clickableText: 'login.terms_and_conditions'.tr(),
                onTap: () => Navigator.pushNamed(context, SignInScreen.routeName),
                clickableTextStyle: TextStyle(color: AppColors.electricBlue),
              ),
              AppGap.h100,
            ],
          ),
        ),
      ),
    );

    return Stack(
      children: [
        FunctionScreenTemplate(
          isShowBottomButton: false,
          screen: contentWidget,
        ),
        if (state is SignUpInProgress)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
