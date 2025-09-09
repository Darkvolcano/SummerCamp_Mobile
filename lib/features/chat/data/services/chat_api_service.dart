import 'package:summercamp/core/network/api_client.dart';

class ChatApiService {
  final ApiClient client;
  ChatApiService(this.client);

  Future<List<dynamic>> fetchMessages() async {
    final res = await client.get('messages');
    return res.data as List;
  }
}
