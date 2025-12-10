import 'dart:io';
import 'package:disposable_provider/disposable_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ed_tech/core/widgets/app_gap.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/profile/bloc/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  static const String routeName = '/editProfile';

  @override
  Widget build(BuildContext context) {
    final controller = DisposableProvider.of<EditProfileController>(context);
    controller.initialize();
    return _EditProfileContent(controller: controller);
  }
}

class _EditProfileContent extends StatelessWidget {
  const _EditProfileContent({required this.controller});

  final EditProfileController controller;

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      isShowAppBar: true,
      title: 'edit_profile.title'.tr(),
      isShowBottomButton: false,
      screen: SingleChildScrollView(
        child: Padding(
          padding: AppPad.h20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppGap.h20,
              _buildAvatarSection(context),
              AppGap.h30,
              _buildSectionTitle('edit_profile.personal_info'.tr()),
              AppGap.h16,
              _buildTextField(
                controller: controller.fullNameController,
                label: 'edit_profile.full_name'.tr(),
                icon: Icons.person_outline,
              ),
              AppGap.h16,
              _buildTextField(
                controller: controller.phoneController,
                label: 'edit_profile.phone'.tr(),
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              AppGap.h16,
              _buildTextField(
                controller: controller.gradeController,
                label: 'edit_profile.grade'.tr(),
                icon: Icons.school_outlined,
              ),
              AppGap.h16,
              _buildTextField(
                controller: controller.subjectController,
                label: 'edit_profile.subject'.tr(),
                icon: Icons.book_outlined,
              ),
              AppGap.h30,
              _buildCertificatesSection(context),
              AppGap.h30,
              ValueListenableBuilder<bool>(
                valueListenable: controller.isLoading,
                builder: (context, isLoading, _) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _handleSave(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'edit_profile.save'.tr(),
                              style: AppTextStyles.textContent1.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
              AppGap.h30,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<File?>(
        valueListenable: controller.avatarFile,
        builder: (context, file, _) {
          return Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: file != null ? FileImage(file) : null,
                child: file == null
                    ? Icon(Icons.person, size: 60, color: AppColors.primary)
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => _pickImage(context, isAvatar: true),
                  child: Container(
                    padding: AppPad.a12,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCertificatesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('edit_profile.certificate'.tr()),
            IconButton(
              onPressed: controller.addCertificate,
              icon: Icon(Icons.add_circle, color: AppColors.primary),
              tooltip: 'Thêm chứng chỉ',
            ),
          ],
        ),
        AppGap.h16,
        ValueListenableBuilder<List<CertificateFormData>>(
          valueListenable: controller.certificates,
          builder: (context, certificates, _) {
            if (certificates.isEmpty) {
              return Center(
                child: TextButton.icon(
                  onPressed: controller.addCertificate,
                  icon: Icon(Icons.add),
                  label: Text('Thêm chứng chỉ'),
                ),
              );
            }
            return Column(
              children: List.generate(certificates.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: _buildCertificateCard(context, certificates[index], index),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCertificateCard(BuildContext context, CertificateFormData cert, int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: AppPad.a16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chứng chỉ ${index + 1}',
                  style: AppTextStyles.textContent1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.removeCertificate(index),
                  icon: Icon(Icons.delete, color: AppColors.crimson),
                  tooltip: 'Xóa',
                ),
              ],
            ),
            AppGap.h12,
            ValueListenableBuilder<File?>(
              valueListenable: cert.file,
              builder: (context, file, _) {
                return GestureDetector(
                  onTap: () => _pickCertificateImage(context, cert),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.offWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: file != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(file, fit: BoxFit.cover, width: double.infinity),
                          )
                        : cert.existingFileUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  cert.existingFileUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                                ),
                              )
                            : _buildImagePlaceholder(),
                  ),
                );
              },
            ),
            AppGap.h12,
            _buildTextField(
              controller: cert.titleController,
              label: 'edit_profile.cert_title'.tr(),
              icon: Icons.workspace_premium,
            ),
            AppGap.h12,
            _buildTextField(
              controller: cert.descriptionController,
              label: 'edit_profile.cert_description'.tr(),
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            AppGap.h12,
            _buildTextField(
              controller: cert.issuedByController,
              label: 'edit_profile.cert_issued_by'.tr(),
              icon: Icons.business,
            ),
            AppGap.h12,
            _buildDateField(
              context: context,
              controller: cert.issuedAtController,
              label: 'edit_profile.cert_issued_at'.tr(),
            ),
            AppGap.h12,
            _buildDateField(
              context: context,
              controller: cert.expiresAtController,
              label: 'edit_profile.cert_expires_at'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 40, color: AppColors.coolGray),
        AppGap.h8,
        Text(
          'edit_profile.add_certificate_image'.tr(),
          style: AppTextStyles.textContent2.copyWith(color: AppColors.coolGray),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.textHeader3.copyWith(color: AppColors.primary),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.coolGray.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.coolGray.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
        suffixIcon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.coolGray.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.coolGray.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _pickImage(BuildContext context, {required bool isAvatar}) async {
    final ImagePicker picker = ImagePicker();

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: Text('edit_profile.gallery'.tr()),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text('edit_profile.camera'.tr()),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null && isAvatar) {
        controller.avatarFile.value = File(image.path);
      }
    }
  }

  Future<void> _pickCertificateImage(BuildContext context, CertificateFormData cert) async {
    final ImagePicker picker = ImagePicker();

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: Text('edit_profile.gallery'.tr()),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text('edit_profile.camera'.tr()),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        cert.file.value = File(image.path);
      }
    }
  }

  Future<void> _handleSave(BuildContext context) async {
    final navigator = Navigator.of(context);

    try {
      await controller.updateProfile();
      Fluttertoast.showToast(
        msg: 'edit_profile.success'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.limeGreen,
        textColor: Colors.white,
      );
      navigator.pop(true);
    } catch (e) {
      debugPrint('Update profile error: $e');
      Fluttertoast.showToast(
        msg: 'edit_profile.error'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.crimson,
        textColor: Colors.white,
      );
    }
  }
}
