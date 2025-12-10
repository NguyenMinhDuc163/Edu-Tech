import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/data/services/user_service.dart';
import 'package:ed_tech/modules/auth/sign_in/model/login_response.dart';
import 'package:ed_tech/modules/profile/bloc/edit_profile_controller.dart';

class ProfileRepo {
  final ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? grade,
    String? subjectSpecialty,
    File? avatarFile,
    List<CertificateFormData>? certificates,
  }) async {
    final res = await apiClient.fetch(
      ApiPath.updateProfile,
      RequestMethod.post,
      asyncRawDataGetter: () async {
        final formData = FormData();

        if (fullName != null && fullName.isNotEmpty) {
          formData.fields.add(MapEntry('full_name', fullName));
        }
        if (phone != null && phone.isNotEmpty) {
          formData.fields.add(MapEntry('phone', phone));
        }
        if (grade != null && grade.isNotEmpty) {
          formData.fields.add(MapEntry('grade', grade));
        }
        if (subjectSpecialty != null && subjectSpecialty.isNotEmpty) {
          formData.fields.add(MapEntry('subject_specialty', subjectSpecialty));
        }

        if (avatarFile != null) {
          final fileName = avatarFile.path.split('/').last;
          formData.files.add(MapEntry(
            'avatar',
            await MultipartFile.fromFile(avatarFile.path, filename: fileName),
          ));
        }

        if (certificates != null && certificates.isNotEmpty) {
          for (var cert in certificates) {
            final title = cert.titleController.text.trim();
            final description = cert.descriptionController.text.trim();
            final issuedBy = cert.issuedByController.text.trim();
            final issuedAt = cert.issuedAtController.text.trim();
            final expiresAt = cert.expiresAtController.text.trim();

            if (title.isNotEmpty) {
              formData.fields.add(MapEntry('certificate_title', title));
            }
            if (description.isNotEmpty) {
              formData.fields.add(MapEntry('certificate_description', description));
            }
            if (issuedBy.isNotEmpty) {
              formData.fields.add(MapEntry('certificate_issued_by', issuedBy));
            }
            if (issuedAt.isNotEmpty) {
              formData.fields.add(MapEntry('certificate_issued_at', issuedAt));
            }
            if (expiresAt.isNotEmpty) {
              formData.fields.add(MapEntry('certificate_expires_at', expiresAt));
            }

            if (cert.file.value != null) {
              final fileName = cert.file.value!.path.split('/').last;
              formData.files.add(MapEntry(
                'certificate_file',
                await MultipartFile.fromFile(cert.file.value!.path, filename: fileName),
              ));
            }
          }
        }

        return formData;
      },
    );

    if (res.code != 200) {
      throw res.message;
    }

    final responseData = res.json['data'];
    if (responseData != null) {
      final user = User.fromJson(responseData);
      final currentUser = UserService.instance.userData;

      List<CertificateData>? certificatesData;
      if (responseData['certificates'] != null) {
        final certList = responseData['certificates'] as List;
        certificatesData = certList.map((certJson) {
          final cert = Certificate.fromJson(certJson);
          return CertificateData(
            id: cert.id,
            title: cert.title,
            description: cert.description,
            issuedBy: cert.issuedBy,
            issuedAt: cert.issuedAt,
            expiresAt: cert.expiresAt,
            fileUrl: cert.fileUrl,
            createdAt: cert.createdAt,
            updatedAt: cert.updatedAt,
          );
        }).toList();
      } else {
        certificatesData = currentUser?.certificates;
      }

      await UserService.instance.saveUserData(
        UserData(
          id: user.id ?? currentUser?.id ?? '',
          username: user.username ?? currentUser?.username ?? '',
          email: user.email ?? currentUser?.email ?? '',
          role: currentUser?.role ?? 'student',
          isPayment: currentUser?.isPayment,
          fullName: user.fullName ?? currentUser?.fullName,
          avatarUrl: user.avatarUrl ?? currentUser?.avatarUrl,
          phone: user.phone ?? currentUser?.phone,
          grade: user.grade ?? currentUser?.grade,
          subjectSpecialty: user.subjectSpecialty ?? currentUser?.subjectSpecialty,
          certificates: certificatesData,
        ),
      );
    }
  }
}
