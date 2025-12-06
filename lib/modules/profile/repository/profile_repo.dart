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
    final res = await apiClient.fetch(
      ApiPath.updateProfile,
      RequestMethod.post,
      asyncDataGetter: () async {
        final Map<String, dynamic> data = {};

        if (fullName != null && fullName.isNotEmpty) {
          data['full_name'] = fullName;
        }
        if (phone != null && phone.isNotEmpty) {
          data['phone'] = phone;
        }
        if (grade != null && grade.isNotEmpty) {
          data['grade'] = grade;
        }
        if (subjectSpecialty != null && subjectSpecialty.isNotEmpty) {
          data['subject_specialty'] = subjectSpecialty;
        }

        if (certificateTitle != null && certificateTitle.isNotEmpty) {
          data['certificate_title'] = certificateTitle;
        }
        if (certificateDescription != null && certificateDescription.isNotEmpty) {
          data['certificate_description'] = certificateDescription;
        }
        if (certificateIssuedBy != null && certificateIssuedBy.isNotEmpty) {
          data['certificate_issued_by'] = certificateIssuedBy;
        }
        if (certificateIssuedAt != null && certificateIssuedAt.isNotEmpty) {
          data['certificate_issued_at'] = certificateIssuedAt;
        }
        if (certificateExpiresAt != null && certificateExpiresAt.isNotEmpty) {
          data['certificate_expires_at'] = certificateExpiresAt;
        }

        if (avatarFile != null) {
          final fileName = avatarFile.path.split('/').last;
          data['avatar'] = await MultipartFile.fromFile(avatarFile.path, filename: fileName);
        }

        if (certificateFile != null) {
          final fileName = certificateFile.path.split('/').last;
          data['certificate_file'] = await MultipartFile.fromFile(certificateFile.path, filename: fileName);
        }

        return data;
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
      if (responseData['certificate'] != null) {
        final cert = Certificate.fromJson(responseData['certificate']);
        certificatesData = [
          CertificateData(
            id: cert.id,
            title: cert.title,
            description: cert.description,
            issuedBy: cert.issuedBy,
            issuedAt: cert.issuedAt,
            expiresAt: cert.expiresAt,
            fileUrl: cert.fileUrl,
            createdAt: cert.createdAt,
            updatedAt: cert.updatedAt,
          )
        ];
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
