import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';
import 'package:sage/services/session_manager/session_controller.dart';

class NotificationsRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  final _sessionController = SessionController();

  Future<Map<String, dynamic>> getNotifications() async {
    final userId = _sessionController.user!.id;
    return _apiServices.get(
      url: '${AppUrl.notifications}/$userId',
    );
  }

  Future<Map<String, dynamic>> markAllNotificationsRead() async {
    final userId = _sessionController.user!.id;
    return _apiServices.patch(
      url: '${AppUrl.notifications}/user/$userId/read-all',
      data: {},
    );
  }
}
