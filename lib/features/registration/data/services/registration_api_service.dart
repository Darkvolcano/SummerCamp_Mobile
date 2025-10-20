import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class RegistrationApiService {
  final ApiClient client;
  RegistrationApiService(this.client);

  Future<List<dynamic>> fetchRegistrations() async {
    final res = await client.get('registration');
    return res.data as List;
  }

  Future<Map<String, dynamic>> fetchRegistrationById(int registrationId) async {
    final res = await client.get('registration/$registrationId');
    return res.data as Map<String, dynamic>;
  }

  Future<void> registerCamp({
    required int campId,
    required List<int> camperIds,
    String? appliedPromotionId,
    String? note,
  }) async {
    try {
      await client.post(
        'registration',
        data: {
          'campId': campId,
          'camperIds': camperIds,
          'appliedPromotionId': appliedPromotionId,
          'note': note,
        },
      );
    } on DioException catch (e) {
      throw mapDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createRegisterPaymentLink(int registrationId) async {
    final res = await client.post('registration/$registrationId/payment-link');
    final data = res.data as Map<String, dynamic>;

    if (data.containsKey('paymentUrl')) {
      return data['paymentUrl'] as String;
    } else {
      throw Exception('Payment URL not found in API response');
    }
  }

  Future<void> cancelRegistration(int registrationId) async {
    await client.delete('registration/$registrationId');
  }
}
