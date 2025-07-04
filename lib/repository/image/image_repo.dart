import 'package:flutter/foundation.dart';
import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';

class ImageRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<String?> uploadImage(String imagePath) async {
    try {
      final response = await _apiServices.multipartUpload(
        url: AppUrl.uploadImage,
        filePath: imagePath,
        fileFieldName: 'image',
      );
      return response['url'] as String;
    } catch (e) {
      debugPrint('[ImageRepository] Upload failed: $e');
    }
    return null;
  }
}
