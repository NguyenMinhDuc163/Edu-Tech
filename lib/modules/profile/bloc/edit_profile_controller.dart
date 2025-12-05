import 'dart:io';
import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:ed_tech/data/services/user_service.dart';
import 'package:ed_tech/modules/profile/repository/profile_repo.dart';

class EditProfileController extends Disposable {
  final ProfileRepo profileRepo;

  EditProfileController({required this.profileRepo});

  // Text controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final gradeController = TextEditingController();
  final subjectController = TextEditingController();
  final certTitleController = TextEditingController();
  final certDescriptionController = TextEditingController();
  final certIssuedByController = TextEditingController();
  final certIssuedAtController = TextEditingController();
  final certExpiresAtController = TextEditingController();

  // Selected files
  final avatarFile = ValueNotifier<File?>(null);
  final certificateFile = ValueNotifier<File?>(null);

  // Loading state
  final isLoading = ValueNotifier<bool>(false);

  // Initialize with current user data
  void initialize() {
    final userData = UserService.instance.userData;
    if (userData != null) {
      fullNameController.text = userData.fullName ?? '';
      phoneController.text = userData.phone ?? '';
      gradeController.text = userData.grade ?? '';
      subjectController.text = userData.subjectSpecialty ?? '';

      // If user has certificates, load the first one
      if (userData.certificates != null && userData.certificates!.isNotEmpty) {
        final cert = userData.certificates!.first;
        certTitleController.text = cert.title ?? '';
        certDescriptionController.text = cert.description ?? '';
        certIssuedByController.text = cert.issuedBy ?? '';
        certIssuedAtController.text = cert.issuedAt ?? '';
        certExpiresAtController.text = cert.expiresAt ?? '';
      }
    }
  }

  Future<void> updateProfile() async {
    isLoading.value = true;

    try {
      await profileRepo.updateProfile(
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        grade: gradeController.text.trim(),
        subjectSpecialty: subjectController.text.trim(),
        avatarFile: avatarFile.value,
        certificateTitle: certTitleController.text.trim(),
        certificateDescription: certDescriptionController.text.trim(),
        certificateIssuedBy: certIssuedByController.text.trim(),
        certificateIssuedAt: certIssuedAtController.text.trim(),
        certificateExpiresAt: certExpiresAtController.text.trim(),
        certificateFile: certificateFile.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    gradeController.dispose();
    subjectController.dispose();
    certTitleController.dispose();
    certDescriptionController.dispose();
    certIssuedByController.dispose();
    certIssuedAtController.dispose();
    certExpiresAtController.dispose();
    avatarFile.dispose();
    certificateFile.dispose();
    isLoading.dispose();
  }
}
