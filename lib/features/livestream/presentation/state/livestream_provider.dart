import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:summercamp/features/livestream/domain/entities/livestream.dart';
import 'package:summercamp/features/livestream/domain/use_cases/update_livestream_room_id.dart';

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

class LivestreamProvider with ChangeNotifier {
  final UpdateLivestreamRoomId updateLivestreamRoomIdUseCase;

  LivestreamProvider(this.updateLivestreamRoomIdUseCase);

  Livestream? _currentLivestream;
  bool _isLoading = false;
  String? _error;

  Livestream? get livestream => _currentLivestream;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> updateLivestreamRoomId(Livestream livestream) async {
    _setLoading(true);
    _error = null;
    notifyListeners();

    try {
      await updateLivestreamRoomIdUseCase(livestream);

      _currentLivestream = livestream;
      notifyListeners();
    } catch (e) {
      _error = "Lỗi khi cập nhật profile: $e";
      rethrow;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
