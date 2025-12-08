import 'package:summercamp/core/network/api_client.dart';

class LivestreamApiService {
  final ApiClient client;

  LivestreamApiService(this.client);

  Future<void> updateLivestreamRoomId(int id, Map<String, dynamic> data) async {
    final res = await client.put('LiveStream/$id', data: data);
    return res.data;
  }
}
