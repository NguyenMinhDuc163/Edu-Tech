import 'dart:io';
import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:ed_tech/data/services/user_service.dart';
import 'package:ed_tech/modules/profile/repository/profile_repo.dart';

class EditProfileController extends Disposable {
  final ProfileRepo profileRepo;

  EditProfileController({required this.profileRepo});

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final gradeController = TextEditingController();
  final subjectController = TextEditingController();
  final certTitleController = TextEditingController();
  final certDescriptionController = TextEditingController();
  final certIssuedByController = TextEditingController();
  final certIssuedAtController = TextEditingController();
  final certExpiresAtController = TextEditingController();

  final avatarFile = ValueNotifier<File?>(null);
  final certificateFile = ValueNotifier<File?>(null);
  final isLoading = ValueNotifier<bool>(false);

  String _initialFullName = '';
  String _initialPhone = '';
  String _initialGrade = '';
  String _initialSubject = '';
  String _initialCertTitle = '';
  String _initialCertDescription = '';
  String _initialCertIssuedBy = '';
  String _initialCertIssuedAt = '';
  String _initialCertExpiresAt = '';

  void initialize() {
    final userData = UserService.instance.userData;
    if (userData != null) {
      _initialFullName = userData.fullName ?? '';
      _initialPhone = userData.phone ?? '';
      _initialGrade = userData.grade ?? '';
      _initialSubject = userData.subjectSpecialty ?? '';

      fullNameController.text = _initialFullName;
      phoneController.text = _initialPhone;
      gradeController.text = _initialGrade;
      subjectController.text = _initialSubject;

      if (userData.certificates != null && userData.certificates!.isNotEmpty) {
        final cert = userData.certificates!.first;
        _initialCertTitle = cert.title ?? '';
        _initialCertDescription = cert.description ?? '';
        _initialCertIssuedBy = cert.issuedBy ?? '';
        _initialCertIssuedAt = cert.issuedAt ?? '';
        _initialCertExpiresAt = cert.expiresAt ?? '';

        certTitleController.text = _initialCertTitle;
        certDescriptionController.text = _initialCertDescription;
        certIssuedByController.text = _initialCertIssuedBy;
        certIssuedAtController.text = _initialCertIssuedAt;
        certExpiresAtController.text = _initialCertExpiresAt;
      }
    }
  }

  Future<void> updateProfile() async {
    isLoading.value = true;

    try {
      final currentFullName = fullNameController.text.trim();
      final currentPhone = phoneController.text.trim();
      final currentGrade = gradeController.text.trim();
      final currentSubject = subjectController.text.trim();
      final currentCertTitle = certTitleController.text.trim();
      final currentCertDescription = certDescriptionController.text.trim();
      final currentCertIssuedBy = certIssuedByController.text.trim();
      final currentCertIssuedAt = certIssuedAtController.text.trim();
      final currentCertExpiresAt = certExpiresAtController.text.trim();

      await profileRepo.updateProfile(
        fullName: currentFullName != _initialFullName ? currentFullName : null,
        phone: currentPhone != _initialPhone ? currentPhone : null,
        grade: currentGrade != _initialGrade ? currentGrade : null,
        subjectSpecialty: currentSubject != _initialSubject ? currentSubject : null,
        avatarFile: avatarFile.value,
        certificateTitle: currentCertTitle != _initialCertTitle ? currentCertTitle : null,
        certificateDescription: currentCertDescription != _initialCertDescription ? currentCertDescription : null,
        certificateIssuedBy: currentCertIssuedBy != _initialCertIssuedBy ? currentCertIssuedBy : null,
        certificateIssuedAt: currentCertIssuedAt != _initialCertIssuedAt ? currentCertIssuedAt : null,
        certificateExpiresAt: currentCertExpiresAt != _initialCertExpiresAt ? currentCertExpiresAt : null,
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
