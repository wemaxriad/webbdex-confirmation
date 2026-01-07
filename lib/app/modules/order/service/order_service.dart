import 'dart:convert';

import 'package:get/get.dart' as dataGet;

import '../../../services/api-list.dart';
import '../../../services/server.dart';
import 'dart:io';
import 'package:dio/dio.dart';

import '../model/orderModel.dart';


class OrderService {
  final Dio _dio = Dio();
  final Server server = Server();

  Future<OrderData?> getOrderHistoryData({int page = 1}) async {
    final response =
    await server.getRequestToken(endPoint: ApiList.orderList!+'?page=${page.toString()}');
    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final model = OrderListModel.fromJson(jsonResponse);
      return model.data;
    }

    return null;
  }
  Future<OrderData?> getAssignOrderHistoryData({int page = 1}) async {
    final response =
    await server.getRequestToken(endPoint: ApiList.orderConfirmAssignList!+'?page=${page.toString()}');
    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final model = OrderListModel.fromJson(jsonResponse);
      return model.data;
    }

    return null;
  }
  Future<OrderData?> getConfirmedOrderHistoryData({int page = 1}) async {
    final response =
    await server.getRequestToken(endPoint: ApiList.orderConfirmList!+'?page=${page.toString()}');
    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final model = OrderListModel.fromJson(jsonResponse);
      return model.data;
    }

    return null;
  }

  Future<bool> storeWithdraw({
    required String token,
    required String amount,
    required String note,
  }) async {
    try {
      final formData = FormData();

      // text fields
      formData.fields.add(MapEntry('amount', amount));
      formData.fields.add(MapEntry('request_note', note));
      final response = await _dio.post(
        ApiList.withdrawRequestStore!,
        data: formData,
        options: Options(
          headers: {
            'Authorization': token,
            'Accept': 'application/json',
          },
        ),
      );
      if(response.statusCode == 200 && response.data['success'] == true) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      dataGet.Get.snackbar('Error', e.response?.data['msg'].toString() ?? 'failed');
      return false;
    }
  }

}
