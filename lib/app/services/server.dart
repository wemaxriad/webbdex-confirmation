import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'api-list.dart';


class Server {
  static String? bearerToken;

  static initToken({String? token}) {
    bearerToken = token!;
  }

  Future<http.Response?> getRequest({required String endPoint}) async {
    print(endPoint);
    try {
      final response = await http.get(
        Uri.parse(endPoint),
        headers: _getHttpHeadersNotToken(),
      );
      return response;
    } catch (e) {
      debugPrint("GET request error: $e");
      return null;
    }
  }
  Future<http.Response?> getRequestToken({required String endPoint}) async {
    print(endPoint);
    try {
      final response = await http.get(
        Uri.parse(endPoint),
        headers: _getHttpHeaders(),
      );
      return response;
    } catch (e) {
      debugPrint("GET request error: $e");
      return null;
    }
  }


  getRequestNotToken({String? endPoint}) async {
    HttpClient client = HttpClient();
    try {
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      return await http.get(Uri.parse(endPoint!), headers: _getHttpHeadersNotToken());
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  getRequestSettings(endPoint) async {
    HttpClient client = HttpClient();
    try {
      return await http.get(Uri.parse(endPoint!), headers: getAuthHeaders());
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  getRequestWithToken(endPoint, body) async {
    HttpClient client = HttpClient();
    try {
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      // Build the URI with query parameters if provided
      Uri uri = Uri.parse(endPoint);
      if (body != null) {
        uri = uri.replace(queryParameters: body);
      }

      return await http.get(uri,headers: _getHttpHeaders());
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  getRequestWithParam({String? endPoint, var categoryId}) async {
    HttpClient client = HttpClient();
    try {
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      return await http.get(Uri.parse("${ApiList.server!}$categoryId/show"), headers: _getHttpHeaders());
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  postRequest({String? endPoint, String? body}) async {
    HttpClient client = HttpClient();
    try {
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      return await http.post(Uri.parse(endPoint!), headers: getAuthHeaders(), body: body);
    } catch (error) {
      //  return null;
    } finally {
      client.close();
    }
  }


  putRequest({String? endPoint, String? body}) async {
    HttpClient client = HttpClient();
    try {
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      return await http.put(Uri.parse(endPoint!), headers: _getHttpHeaders(), body: body);
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  postRequestWithToken({String? endPoint, String? body}) async {
    HttpClient client = HttpClient();
    try {
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      return await http.post(Uri.parse(endPoint!), headers: _getHttpHeaders(), body: body);
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }


  putRequestWithToken(endPoint, body, token) async {
    HttpClient client = HttpClient();
    try {
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      Uri uri = Uri.parse(endPoint);
      if (body != null) {
        uri = uri.replace(queryParameters: body);
      }
      return await http.put(uri,headers: _getHttpHeaders());
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  multipartRequest({String? endPoint, body, filepath, type}) async {
    Map<String, String> headers = {
      'Authorization': bearerToken!,
      'apiKey': ApiList.apiCheckKey!,
      'Content-Type': 'multipart/form-data',
    };
    HttpClient client = HttpClient();
    try {
      var request;
      if (type) {
        request = http.MultipartRequest('POST', Uri.parse(endPoint!))
          ..fields.addAll(body)
          ..headers.addAll(headers)
          ..files.add(await http.MultipartFile.fromPath('image_id', filepath));
      } else {
        request = http.MultipartRequest('POST', Uri.parse(endPoint!))
          ..fields.addAll(body)
          ..headers.addAll(headers);
      }
      return await request.send();
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  multipartFileRequest({String? endPoint, body, filepath, pickedSignatureImage, type}) async {
    Map<String, String> headers = {
      'Authorization': bearerToken!,
      'apiKey': ApiList.apiCheckKey!,
      'Content-Type': 'multipart/form-data',
    };
    HttpClient client = HttpClient();
    try {
      var request;
      if (type) {
        request = http.MultipartRequest('POST', Uri.parse(endPoint!))
          ..fields.addAll(body)
          ..headers.addAll(headers)
          ..files.add(await http.MultipartFile.fromPath('image', filepath))
          ..files.add(await http.MultipartFile.fromPath('signatureImage', pickedSignatureImage));
      } else {
        request = http.MultipartRequest('POST', Uri.parse(endPoint!))
          ..fields.addAll(body)
          ..headers.addAll(headers);
      }
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(endPoint);
      print(responseString);
      return responseString;
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  getRequestParam({String? endPoint, body}) async {
    HttpClient client = HttpClient();
    var uri = Uri.https(ApiList.apiUrl!, ApiList.apiEndPoint! + endPoint!, body);
    try {
      return await http.get(uri, headers: _getHttpHeaders());
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  deleteRequest({String? endPoint}) async {
    HttpClient client = HttpClient();
    try {
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      return await http.delete(Uri.parse(endPoint!), headers: _getHttpHeaders());
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  static Map<String, String> _getHttpHeaders() {
    Map<String, String> headers = new Map<String, String>();
    headers['Authorization'] = bearerToken!;
    headers['apiKey'] = ApiList.apiCheckKey!;
    headers['content-type'] = 'application/json';
    return headers;
  }

  static Map<String, String> _getHttpHeadersNotToken() {
    Map<String, String> headers = new Map<String, String>();
    headers['apiKey'] = ApiList.apiCheckKey!;
    headers['content-type'] = 'application/json';
    return headers;
  }

  static Map<String, String> getAuthHeaders() {
    Map<String, String> headers = new Map<String, String>();
    headers['content-type'] = 'application/json';
    headers['apiKey'] = ApiList.apiCheckKey!;

    return headers;
  }
}
