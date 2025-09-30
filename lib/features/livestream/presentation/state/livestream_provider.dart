import 'dart:convert';
import 'package:http/http.dart' as http;

//Auth token we will use to generate a liveStream and connect to it
String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI0ZWQzZTNmNC0zMjBlLTQ5ZGYtOWM3ZS1kZjViZWMxNmIxOTkiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTc1OTEzNTYwOSwiZXhwIjoxNzc0Njg3NjA5fQ.5m-pLjkx_fqpc4nYWeEl-Xkbt_8uIg8o2tlnjlY-irU";
// API call to create livestream
Future<String> createLivestream() async {
  final Uri getlivestreamIdUrl = Uri.parse(
    'https://api.videosdk.live/v2/rooms',
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
