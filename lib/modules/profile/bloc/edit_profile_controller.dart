import 'dart:io';
import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:ed_tech/data/services/user_service.dart';
import 'package:ed_tech/modules/profile/repository/profile_repo.dart';

class CertificateFormData {
  final String? id;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController issuedByController;
  final TextEditingController issuedAtController;
  final TextEditingController expiresAtController;
  final ValueNotifier<File?> file;
  final String? existingFileUrl;

  CertificateFormData({
    this.id,
    String? title,
    String? description,
    String? issuedBy,
    String? issuedAt,
    String? expiresAt,
    File? fileValue,
    this.existingFileUrl,
  })  : titleController = TextEditingController(text: title),
        descriptionController = TextEditingController(text: description),
        issuedByController = TextEditingController(text: issuedBy),
        issuedAtController = TextEditingController(text: issuedAt),
        expiresAtController = TextEditingController(text: expiresAt),
        file = ValueNotifier<File?>(fileValue);

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    issuedByController.dispose();
    issuedAtController.dispose();
    expiresAtController.dispose();
    file.dispose();
  }
}

class EditProfileController extends Disposable {
  final ProfileRepo profileRepo;

  EditProfileController({required this.profileRepo});

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final gradeController = TextEditingController();
  final subjectController = TextEditingController();

  final avatarFile = ValueNotifier<File?>(null);
  final certificates = ValueNotifier<List<CertificateFormData>>([]);
  final isLoading = ValueNotifier<bool>(false);

  String _initialFullName = '';
  String _initialPhone = '';
  String _initialGrade = '';
  String _initialSubject = '';

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
        final certList = userData.certificates!.map((cert) {
          return CertificateFormData(
            id: cert.id,
            title: cert.title,
            description: cert.description,
            issuedBy: cert.issuedBy,
            issuedAt: cert.issuedAt,
            expiresAt: cert.expiresAt,
            existingFileUrl: cert.fileUrl,
          );
        }).toList();
        certificates.value = certList;
      }
    }
  }

  void addCertificate() {
    final newList = List<CertificateFormData>.from(certificates.value);
    newList.add(CertificateFormData());
    certificates.value = newList;
  }

  void removeCertificate(int index) {
    final newList = List<CertificateFormData>.from(certificates.value);
    newList[index].dispose();
    newList.removeAt(index);
    certificates.value = newList;
  }

  Future<void> updateProfile() async {
    isLoading.value = true;

    try {
      final currentFullName = fullNameController.text.trim();
      final currentPhone = phoneController.text.trim();
      final currentGrade = gradeController.text.trim();
      final currentSubject = subjectController.text.trim();

      await profileRepo.updateProfile(
        fullName: currentFullName != _initialFullName ? currentFullName : null,
        phone: currentPhone != _initialPhone ? currentPhone : null,
        grade: currentGrade != _initialGrade ? currentGrade : null,
        subjectSpecialty: currentSubject != _initialSubject ? currentSubject : null,
        avatarFile: avatarFile.value,
        certificates: certificates.value,
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
    avatarFile.dispose();
    for (var cert in certificates.value) {
      cert.dispose();
    }
    certificates.dispose();
    isLoading.dispose();
  }
}
