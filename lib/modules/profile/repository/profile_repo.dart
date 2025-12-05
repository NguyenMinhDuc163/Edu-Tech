import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/data/services/user_service.dart';
import 'package:ed_tech/modules/auth/sign_in/model/login_response.dart';

class ProfileRepo {
  final ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? grade,
    String? subjectSpecialty,
    File? avatarFile,
    String? certificateTitle,
    String? certificateDescription,
    String? certificateIssuedBy,
    String? certificateIssuedAt,
    String? certificateExpiresAt,
    File? certificateFile,
  }) async {
    final formData = FormData();

    // Add text fields if not null
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

    // Add certificate fields if not null
    if (certificateTitle != null && certificateTitle.isNotEmpty) {
      formData.fields.add(MapEntry('certificate_title', certificateTitle));
    }
    if (certificateDescription != null && certificateDescription.isNotEmpty) {
      formData.fields.add(MapEntry('certificate_description', certificateDescription));
    }
    if (certificateIssuedBy != null && certificateIssuedBy.isNotEmpty) {
      formData.fields.add(MapEntry('certificate_issued_by', certificateIssuedBy));
    }
    if (certificateIssuedAt != null && certificateIssuedAt.isNotEmpty) {
      formData.fields.add(MapEntry('certificate_issued_at', certificateIssuedAt));
    }
    if (certificateExpiresAt != null && certificateExpiresAt.isNotEmpty) {
      formData.fields.add(MapEntry('certificate_expires_at', certificateExpiresAt));
    }

    // Add files if not null
    if (avatarFile != null) {
      final fileName = avatarFile.path.split('/').last;
      formData.files.add(MapEntry(
        'avatar',
        await MultipartFile.fromFile(avatarFile.path, filename: fileName),
      ));
    }

    if (certificateFile != null) {
      final fileName = certificateFile.path.split('/').last;
      formData.files.add(MapEntry(
        'certificate_file',
        await MultipartFile.fromFile(certificateFile.path, filename: fileName),
      ));
    }

    final res = await apiClient.fetch(
      ApiPath.updateProfile,
      RequestMethod.post,
      rawData: formData as dynamic,
    );

    if (res.code != 200) {
      throw res.message;
    }

    // Parse response and update UserService
    final responseData = res.json['data'];
    if (responseData != null) {
      final user = User.fromJson(responseData);
      final certificates = responseData['certificate'] != null
          ? [Certificate.fromJson(responseData['certificate'])]
          : null;

      await UserService.instance.saveUserData(
        UserData(
          id: user.id ?? UserService.instance.userData?.id ?? '',
          username: user.username ?? UserService.instance.userData?.username ?? '',
          email: user.email ?? UserService.instance.userData?.email ?? '',
          role: UserService.instance.userData?.role ?? 'student',
          isPayment: UserService.instance.userData?.isPayment,
          fullName: user.fullName,
          avatarUrl: user.avatarUrl,
          phone: user.phone,
          grade: user.grade,
          subjectSpecialty: user.subjectSpecialty,
          certificates: certificates?.map((cert) => CertificateData(
            id: cert.id,
            title: cert.title,
            description: cert.description,
            issuedBy: cert.issuedBy,
            issuedAt: cert.issuedAt,
            expiresAt: cert.expiresAt,
            fileUrl: cert.fileUrl,
            createdAt: cert.createdAt,
            updatedAt: cert.updatedAt,
          )).toList(),
        ),
      );
    }
  }
}
