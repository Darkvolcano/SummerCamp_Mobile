import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

//Auth token we will use to generate a liveStream and connect to it
String token = dotenv.env['VIDEO_SDK_TOKEN'] ?? '';
// API call to create livestream
Future<String> createLivestream() async {
  final Uri getlivestreamIdUrl = Uri.parse(
    dotenv.env['LIVESTREAM_ID_URL'] ?? '',
  );
  final http.Response liveStreamIdResponse = await http.post(
    getlivestreamIdUrl,
    headers: {"Authorization": token},
  );

  if (liveStreamIdResponse.statusCode != 200) {
    throw Exception(json.decode(liveStreamIdResponse.body)["error"]);
  }
  var liveStreamID = json.decode(liveStreamIdResponse.body)['roomId'];
  return liveStreamID;
}
