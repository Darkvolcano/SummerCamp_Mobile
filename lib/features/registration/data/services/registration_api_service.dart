import 'package:summercamp/core/network/api_client.dart';

class RegistrationApiService {
  final ApiClient client;
  RegistrationApiService(this.client);

  Future<List<dynamic>> fetchRegistrations() async {
    final res = await client.get('registration');
    return res.data as List;
  }

  // Future<Map<String, dynamic>> registerCamp({
  //   required String campId,
  //   required String camperId,
  //   required String paymentId,
  //   required String appliedPromotionId,
  //   required String registrationCreateAt,
  // }) async {
  //   final res = await client.post(
  //     'registration',
  //     data: {
  //       'campId': campId,
  //       'camperId': camperId,
  //       'paymentId': paymentId,
  //       'appliedPromotionId': appliedPromotionId,
  //       'registrationCreateAt': registrationCreateAt,
  //     },
  //   );
  //   final data = res.data as Map<String, dynamic>;

  //   return data;
  // }
  Future<String> registerCamp({
    required int campId,
    required List<int> camperIds,
    String? appliedPromotionId,
  }) async {
    final res = await client.post(
      'registration',
      data: {
        'campId': campId,
        'camperIds': camperIds,
        'appliedPromotionId': appliedPromotionId,
      },
    );
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
