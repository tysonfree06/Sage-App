import 'dart:io';

import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';

class ImageUploadRepository {
  final BaseApiServices api = NetworkApiService();

  Future<Map<String, dynamic>> uploadImage({
    required File file,
  }) async {
    return api.multipartUpload(url: AppUrl.uploadImage, file: file);
  }
}
