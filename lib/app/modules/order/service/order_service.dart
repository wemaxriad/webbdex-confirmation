import 'dart:convert';

import 'package:get/get.dart' as dataGet;

import '../../../services/api-list.dart';
import '../../../services/server.dart';
import 'dart:io';
import 'package:dio/dio.dart';

import '../model/orderDetailsModel.dart';
import '../model/orderModel.dart';


class OrderService {
  final Dio _dio = Dio();
  final Server server = Server();

  Future<OrderData?> getOrderHistoryData({int page = 1, String? search,}) async {
    final response =
    await server.getRequestToken(endPoint: ApiList.orderList!+'?page=${page.toString()}&search=${search ?? ''}');
    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final model = OrderListModel.fromJson(jsonResponse);
      return model.data;
    }

    return null;
  }
  Future<OrderData?> getAssignOrderHistoryData({int page = 1, String? search,}) async {
    final response =
    await server.getRequestToken(endPoint: ApiList.orderConfirmAssignList!+'?page=${page.toString()}&search=${search ?? ''}');
    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final model = OrderListModel.fromJson(jsonResponse);
      return model.data;
    }

    return null;
  }
  Future<OrderData?> getConfirmedOrderHistoryData({int page = 1, String? search,}) async {
    final response =
    await server.getRequestToken(endPoint: ApiList.orderConfirmList!+'?page=${page.toString()}&search=${search ?? ''}');
    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final model = OrderListModel.fromJson(jsonResponse);
      return model.data;
    }

    return null;
  }

  Future<Order?> getConfirmedOrderDetailsData(tenantID,orderID,) async {
    final response =
    await server.getRequestToken(endPoint: ApiList.orderPreview!+'${tenantID}/${orderID}');
    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final model = OrderDetailsModel.fromJson(jsonResponse);
      return model.order;
    }

    return null;
  }

  Future<bool> changeOrderStatus({
    required String token,
    required String orderId,
    required String tenantId,
    required String status,
    required String note,
    required String callSid,
    File? audioFile,
    File? imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'order_id': orderId,
        'tenant_id': tenantId,
        'confirmation_status': status,
        'call_note': note,
        if (audioFile != null)
          'confirmation_call_record': await MultipartFile.fromFile(
            audioFile.path,
            filename: audioFile.path.split('/').last,
          ),
        if (imageFile != null)
          'confirmation_call_image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await _dio.post(
        ApiList.orderStatusUpdate!,
        data: formData,
        options: Options(headers: {
          'Authorization': token,
          'Accept': 'application/json',
        }),
      );

      return response.statusCode == 200 &&
          response.data['status'] == true;
    } on DioException catch (e) {
      print(e.response?.data);
      dataGet.Get.snackbar(
        'Error',
        e.response?.data['msg'] ?? 'Something went wrong',
      );
      return false;
    }
  }


}
