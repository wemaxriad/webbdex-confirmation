import 'dart:convert';

import '../../../services/api-list.dart';
import '../../../services/server.dart';
import '../model/dashboardModel.dart';

class DashboardService {
  final Server server = Server();

  Future<DashboardData?> getDashboardData() async {
    final response =
    await server.getRequestToken(endPoint: ApiList.dashboard!);

    if (response != null && response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final model = DashboardModel.fromJson(jsonResponse);
      return model.data;
    }

    return null;
  }
}
