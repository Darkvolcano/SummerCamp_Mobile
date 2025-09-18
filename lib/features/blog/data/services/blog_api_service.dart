import 'package:summercamp/core/network/api_client.dart';

class BlogApiService {
  final ApiClient client;
  BlogApiService(this.client);

  Future<List<dynamic>> fetchBlogs() async {
    final res = await client.get('blogs');
    return res.data as List;
  }
}
