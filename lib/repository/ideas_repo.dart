import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';
import 'package:sage/services/session_manager/session_controller.dart';

class IdeasRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  final _sessionController = SessionController();
  Future<Map<String, dynamic>> getIdeasFeed() async {
    final userId = _sessionController.user?.id;
    return _apiServices.get(
      url: '${AppUrl.getIdeasFeed}?userId=$userId',
    );
  }

  Future<Map<String, dynamic>> addBookmark(String ideaId) async {
    final userId = _sessionController.user?.id;
    return _apiServices.post(
      url: '${AppUrl.ideas}/$ideaId/save',
      data: {
        'userId': userId,
      },
    );
  }

  Future<Map<String, dynamic>> removeBookmark(String ideaId) async {
    final userId = _sessionController.user?.id;
    return _apiServices.delete(
      url: '${AppUrl.ideas}/$ideaId/save',
      data: {
        'userId': userId,
      },
    );
  }

  //Delete added idea
  Future<Map<String, dynamic>> deleteIdea(String ideaId) async {
    final userId = _sessionController.user?.id;
    return _apiServices.delete(
      url: '${AppUrl.ideas}/$ideaId',
      data: {
        'userId': userId,
      },
    );
  }

  Future<Map<String, dynamic>> dislikeIdea(String ideaId) async {
    final userId = _sessionController.user?.id;
    return _apiServices.post(
      url: '${AppUrl.ideas}/$ideaId/dislike',
      data: {
        'userId': userId,
      },
    );
  }

  Future<Map<String, dynamic>> addIdea(Map<String, dynamic> ideaData) async {
    return _apiServices.post(
      url: AppUrl.ideas,
      data: ideaData,
    );
  }

  Future<Map<String, dynamic>> updateIdea(
    String ideaId,
    Map<String, dynamic> ideaData,
  ) async {
    return _apiServices.patch(
      url: '${AppUrl.ideas}/$ideaId',
      data: ideaData,
    );
  }

  Future<Map<String, dynamic>> getSavedIdeas(String type) async {
    final userId = _sessionController.user?.id;

    return _apiServices.get(
      url: AppUrl.getSavedIdeas,
      queryParams: {
        'userId': userId,
        'type': type,
      },
    );
  }

  Future<Map<String, dynamic>> getAddedIdeas() async {
    final userId = _sessionController.user?.id;

    return _apiServices.get(
      url: '${AppUrl.ideas}/mine/$userId',
    );
  }
}
