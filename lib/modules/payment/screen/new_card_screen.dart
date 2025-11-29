import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/core/widgets/template/button_widget.dart';
import 'package:ed_tech/core/widgets/text_input_custom.dart';
import 'package:ed_tech/modules/payment/screen/confirm_screen.dart';

import '../../../init.dart';

class NewCardScreen extends StatefulWidget {
  const NewCardScreen({super.key});
  static const String routeName = '/newCardScreen';
  @override
  State<NewCardScreen> createState() => _NewCardScreenState();
}

class _NewCardScreenState extends State<NewCardScreen> {
  TextEditingController cardOwnerController = TextEditingController();
  TextEditingController expController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      titleButtonBottom: "payment.add_card".tr(),
      title: "payment.add_new_card".tr(),
      onClickBottomButton: () => Navigator.pushNamed(context, ConfirmScreen.routeName),
      screen: Padding(
        padding: AppPad.h22v15,
        child: Column(
          spacing: 20,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: ButtonWidget(
                    titleWidget: Image.asset(IconPath.iconMaster),
                    backgroundColor: AppColors.lightGray,
                    padding: AppPad.v14,
                    boderRadius: AppBorderRadius.a12,
                  ),
                ),
                Expanded(
                  child: ButtonWidget(
                    titleWidget: Image.asset(IconPath.iconPaypal),
                    backgroundColor: AppColors.lightGray,
                    padding: AppPad.v14,
                    boderRadius: AppBorderRadius.a12,
                  ),
                ),
                Expanded(
                  child: ButtonWidget(
                    titleWidget: Image.asset(IconPath.iconBank),
                    backgroundColor: AppColors.lightGray,
                    boderRadius: AppBorderRadius.a12,
                    padding: AppPad.v14,
                  ),
                ),
              ],
            ),
            TextInputCustom(
              controller: cardOwnerController,
              fillColor: true,
              label: 'payment.card_owner'.tr(),
              hintText: "payment.hint_card_owner".tr(),
              titleStyle: AppTextStyles.textContent1.copyWith(
                fontWeight: FontWeight.bold,
              ),
              borderRadius: AppBorderRadius.a8,
            ),
            TextInputCustom(
              controller: cardNumberController,
              fillColor: true,
              label: 'payment.card_number'.tr(),
              hintText: "payment.hint_card_number".tr(),
              titleStyle: AppTextStyles.textContent1.copyWith(
                fontWeight: FontWeight.bold,
              ),
              borderRadius: AppBorderRadius.a8,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 20,
              children: [
                Expanded(
                  child: TextInputCustom(
                    controller: expController,
                    fillColor: true,
                    label: 'payment.exp'.tr(),
                    hintText: "payment.hint_exp".tr(),
                    titleStyle: AppTextStyles.textContent1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    borderRadius: AppBorderRadius.a8,
                  ),
                ),
                Expanded(
                  child: TextInputCustom(
                    controller: cvvController,
                    fillColor: true,
                    label: 'payment.cvv'.tr(),
                    hintText: "payment.hint_cvv".tr(),
                    titleStyle: AppTextStyles.textContent1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    borderRadius: AppBorderRadius.a8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
