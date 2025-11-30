import 'package:disposable_provider/disposable_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/widgets/app_gap.dart';
import 'package:ed_tech/core/widgets/text_input_custom.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/reset_pass_controller.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/reset_pass_cubit.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/reset_pass_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  static const String routeName = '/changePassword';
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final ResetPassController controller = context.read();

    return BlocListener<ResetPassCubit, ResetPassState>(
      listener: controller.handleListener,
      listenWhen:
          (previous, next) => previous.runtimeType != next.runtimeType,
      child: _ResetPasswordContent(controller: controller),
    );
  }
}

class _ResetPasswordContent extends StatelessWidget {
  const _ResetPasswordContent({required this.controller});

  final ResetPassController controller;

  @override
  Widget build(BuildContext context) {
    final ResetPassState state = context.watch<ResetPassCubit>().state;

    final Widget contentWidget = SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: AppPad.h22v10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: height_30,
            children: [
              Text(
                'common.change_password'.tr(),
                style: AppTextStyles.textHeader1,
              ),
              AppGap.g2,
              TextInputCustom(
                label: 'forgot_password.old_password'.tr(),
                controller: controller.oldPasswordController,
                hintText: 'forgot_password.enter_old_password'.tr(),
              ),
              TextInputCustom(
                label: 'forgot_password.new_password'.tr(),
                controller: controller.passwordController,
                hintText: 'forgot_password.enter_new_password_hint'.tr(),
                validator: (text) {
                  return text.length >= 6;
                },
              ),
              TextInputCustom(
                label: 'forgot_password.confirm_password'.tr(),
                controller: controller.confirmPasswordController,
                hintText: 'forgot_password.enter_confirm_password'.tr(),
                validator: (text) {
                  return text.length >= 6 && text == controller.passwordController.text;
                },
              ),
              AppGap.h50,
              Text(
                'forgot_password.password_requirement'.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.textContent3.copyWith(
                  color: AppColors.coolGray,
                ),
              ),
              AppGap.g1,
            ],
          ),
        ),
      ),
    );

    return Stack(
      children: [
        FunctionScreenTemplate(
          titleButtonBottom: 'common.change_password'.tr(),
          onClickBottomButton: () {
            controller.onChangePassword(context);
          },
          screen: contentWidget,
        ),
        if (state is ResetPassInProgress)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
