import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ed_tech/core/widgets/app_gap.dart';
import 'package:ed_tech/core/widgets/text_input_custom.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/forgot_pass_controller.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/forgot_pass_cubit.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/forgot_pass_state.dart';

// chia widget nho ra  => dung watch
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const String routeName = '/forgotPassword';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ForgotPassController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<ForgotPassController>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPassCubit, ForgotPassState>(
      listener: controller.handleListener,
      listenWhen: (previous, next) => previous.runtimeType != next.runtimeType,
      child: _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  @override
  Widget build(BuildContext context) {
    final ForgotPassState state = context.watch<ForgotPassCubit>().state;

    return Stack(
      children: [
        const _ForgotPasswordContent(),
        if (state is ForgotPassInProgress)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _ForgotPasswordContent extends StatelessWidget {
  const _ForgotPasswordContent();

  @override
  Widget build(BuildContext context) {
    final ForgotPassController controller = context.read();

    final Widget content = Padding(
      padding: AppPad.h22v10,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            spacing: height_30,
            children: [
              Text("forgot_password.title".tr(), style: AppTextStyles.textHeader1),
              SvgPicture.asset(ImagePath.imgForgotPassword),
              AppGap.g2,
              TextInputCustom(
                label: 'Email',
                controller: controller.emailController,
                hintText: "Nhập email của bạn",
              ),
              AppGap.h100,
              Text(
                'Nhập email để nhận liên kết đặt lại mật khẩu',
                textAlign: TextAlign.center,
                style: AppTextStyles.textContent3.copyWith(color: AppColors.coolGray),
              ),
              AppGap.g1,
            ],
          ),
        ),
      ),
    );

    return FunctionScreenTemplate(
      titleButtonBottom: "Xác nhận",
      onClickBottomButton: () {
        controller.onSendResetPasswordEmail(context);
      },
      screen: content,
    );
  }
}
