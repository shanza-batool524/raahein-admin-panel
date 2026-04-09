import 'dart:developer';
import '../../res/app_url/app_url.dart';
import '../models/route_model.dart';
import '../models/fare_table_model.dart';
import '../network/network_api_service.dart';

class FareRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<RouteModel> createRoute(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.postApi(
        url: AppUrl.createRouteApi,
        data: data,
        isHeaderRequired: true,
      );
      return RouteModel.fromJson(response);
    } catch (e) {
      log("💥 createRoute Error: $e");
      rethrow;
    }
  }

  Future<List<RouteModel>> getRoutes() async {
    try {
      final response = await _apiService.getApi(
        url: AppUrl.createRouteApi,
        isHeaderRequired: true,
      );
      if (response != null && response is List) {
        return response.map((e) => RouteModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      log("💥 getRoutes Error: $e");
      rethrow;
    }
  }

  Future<dynamic> updateRoute(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.putApi(
        url: AppUrl.updateRouteApi(id),
        data: data,
        isHeaderRequired: true,
      );
      return response;
    } catch (e) {
      log("💥 updateRoute Error: $e");
      rethrow;
    }
  }

  Future<dynamic> deleteRoute(int id) async {
    try {
      final response = await _apiService.deleteApi(
        url: AppUrl.deleteRouteApi(id),
        isHeaderRequired: true,
      );
      return response;
    } catch (e) {
      log("💥 deleteRoute Error: $e");
      rethrow;
    }
  }

  Future<dynamic> addFare(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.postApi(
        url: AppUrl.addFareApi,
        data: data,
        isHeaderRequired: true,
      );
      return response;
    } catch (e) {
      log("💥 addFare Error: $e");
      rethrow;
    }
  }

  Future<FareTableResponse> getFareTable(int routeId) async {
    try {
      final response = await _apiService.getApi(
        url: AppUrl.previewFareTableApi(routeId),
        isHeaderRequired: true,
      );
      return FareTableResponse.fromJson(response);
    } catch (e) {
      log("💥 getFareTable Error: $e");
      rethrow;
    }
  }

  Future<dynamic> bulkUploadFares(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.postApi(
        url: AppUrl.bulkUploadFaresApi,
        data: data,
        isHeaderRequired: true,
      );
      return response;
    } catch (e) {
      log("💥 bulkUploadFares Error: $e");
      rethrow;
    }
  }

  Future<dynamic> deleteFare(int id) async {
    try {
      final response = await _apiService.deleteApi(
        url: AppUrl.deleteFareApi(id),
        isHeaderRequired: true,
      );
      return response;
    } catch (e) {
      log("💥 deleteFare Error: $e");
      rethrow;
    }
  }
}
