import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';

class SettingsRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  Future<Map<String, dynamic>> sendUserQuery(Map<String, dynamic> data) async {
    return _apiServices.post(
      url: AppUrl.contactUs,
      data: data,
    );
  }

  //Location
  Future<Map<String, dynamic>> getCountries() async {
    return _apiServices.get(
      url: AppUrl.countries,
    );
  }

  Future<Map<String, dynamic>> getStates(
    String countryCode,
  ) async {
    return _apiServices.get(
      url: '${AppUrl.states}/$countryCode',
    );
  }

  Future<Map<String, dynamic>> getCities(
    String countryCode,
    String stateCode,
  ) async {
    return _apiServices.get(
      url: '${AppUrl.cities}/$countryCode/$stateCode',
    );
  }
}
