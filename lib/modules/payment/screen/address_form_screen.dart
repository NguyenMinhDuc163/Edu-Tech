import 'package:disposable_provider/disposable_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/core/widgets/switch_botton_widget.dart';
import 'package:ed_tech/core/widgets/text_input_custom.dart';
import 'package:ed_tech/modules/payment/bloc/address_form_controller.dart';
import 'package:ed_tech/modules/payment/screen/payment_method_screen.dart';

import '../../../init.dart';

class AddressFormScreen extends StatelessWidget {
  const AddressFormScreen({super.key});
  static const String routeName = '/addressFormScreen';

  @override
  Widget build(BuildContext context) {
    return DisposableProvider(
      create: (BuildContext context) => AddressFormController(),
      child: const _AddressFormContent(),
    );
  }
}

class _AddressFormContent extends StatelessWidget {
  const _AddressFormContent();

  @override
  Widget build(BuildContext context) {
    final AddressFormController controller = DisposableProvider.of<AddressFormController>(context);

    return FunctionScreenTemplate(
      titleButtonBottom: "payment.save_address".tr(),
      title: "payment.address".tr(),
      onClickBottomButton:
          () => Navigator.pushNamed(context, PaymentMethodScreen.routeName),
      screen: Padding(
        padding: AppPad.h22v15,
        child: Column(
          spacing: 20,
          children: [
            TextInputCustom(
              controller: controller.nameController,
              fillColor: true,
              label: 'payment.name'.tr(),
            hintText: "payment.hint_name".tr(),
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
                    controller: controller.countryController,
                    fillColor: true,
                    label: 'payment.country'.tr(),
                    hintText: "payment.hint_country".tr(),
                    titleStyle: AppTextStyles.textContent1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    borderRadius: AppBorderRadius.a8,
                  ),
                ),
                Expanded(
                  child: TextInputCustom(
                    controller: controller.cityController,
                    fillColor: true,
                    label: 'payment.city'.tr(),
                    hintText: "payment.hint_city".tr(),
                    titleStyle: AppTextStyles.textContent1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    borderRadius: AppBorderRadius.a8,
                  ),
                ),
              ],
            ),
            TextInputCustom(
              controller: controller.phoneController,
              fillColor: true,
              label: 'payment.phone_number'.tr(),
            hintText: "payment.hint_phone".tr(),
              titleStyle: AppTextStyles.textContent1.copyWith(
                fontWeight: FontWeight.bold,
              ),
              borderRadius: AppBorderRadius.a8,
            ),
            TextInputCustom(
              controller: controller.addressController,
              fillColor: true,
              label: 'payment.address'.tr(),
            hintText: "payment.hint_address".tr(),
              titleStyle: AppTextStyles.textContent1.copyWith(
                fontWeight: FontWeight.bold,
              ),
              borderRadius: AppBorderRadius.a8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'payment.save_as_primary_address'.tr(),
                  style: AppTextStyles.textContent2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SwitchBottomWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
