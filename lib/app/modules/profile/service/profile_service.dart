import 'dart:convert';

import 'package:get/get.dart' as dataGet;

import '../../../services/api-list.dart';
import '../../../services/server.dart';
import '../../balance/model/walletHistoryModel.dart';
import '../model/documentTypesModel.dart';
import '../model/profileModel.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class ProfiledService {
  final Dio _dio = Dio();
  final Server server = Server();

  Future<UserDetails?> getProfiledData() async {
    final response =
    await server.getRequestToken(endPoint: ApiList.profile!);

    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final model = ProfileModel.fromJson(jsonResponse);
      return model.userDetails;
    }

    return null;
  }

  Future<WalletData?> getBalance() async {
    final response =
    await server.getRequestToken(endPoint: ApiList.wallet!);

    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final model = WalletHistoryModel.fromJson(jsonResponse);
      return model.data;
    }

    return null;
  }

  Future<DocumentTypesModel?> getDocumentTypeData() async {
    final response =
    await server.getRequestNotToken(endPoint: ApiList.documentTypes!);

    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final model = DocumentTypesModel.fromJson(jsonResponse);
      return model;
    }

    return null;
  }


  Future<bool> storeDocuments({
    required String token,
    required String nidNumber,
    required String passportNumber,
    required Map<int, File?> files, // document_type_id -> File
  }) async {
    try {
      final formData = FormData();

      // text fields
      formData.fields.add(MapEntry('nid_number', nidNumber));
      formData.fields.add(MapEntry('passport_number', passportNumber));

      // documents
      for (final entry in files.entries) {
        if (entry.value != null) {
          formData.files.add(
            MapEntry(
              'document[${entry.key}]',
              await MultipartFile.fromFile(
                entry.value!.path,
                filename: entry.value!.path.split('/').last,
              ),
            ),
          );
        }
      }

      final response = await _dio.post(
        ApiList.confirmationDocumentsStore!,
        data: formData,
        options: Options(
          headers: {
            'Authorization': token,
            'Accept': 'application/json',
          },
        ),
      );

      return response.statusCode == 200 && response.data['status'] == true;
    } on DioException catch (e) {
      dataGet.Get.snackbar('Error', e.response?.data['message'].toString() ?? 'Upload failed');
      return false;
    }
  }

}
