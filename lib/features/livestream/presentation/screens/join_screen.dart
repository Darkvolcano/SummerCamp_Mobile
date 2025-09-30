import 'package:flutter/material.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/features/livestream/presentation/screens/ils_screen.dart';
import 'package:summercamp/features/livestream/presentation/state/livestream_provider.dart';
import 'package:videosdk/videosdk.dart';

class JoinScreen extends StatelessWidget {
  final _livestreamIdController = TextEditingController();

  JoinScreen({super.key});

  void onCreateButtonPressed(BuildContext context) async {
    await createLivestream().then((liveStreamId) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ILSScreen(
            liveStreamId: liveStreamId,
            token: token,
            mode: Mode.SEND_AND_RECV,
          ),
        ),
      );
    });
  }

  void onJoinButtonPressed(BuildContext context, Mode mode) {
    String liveStreamId = _livestreamIdController.text;
    var re = RegExp("\\w{4}\\-\\w{4}\\-\\w{4}");
    if (liveStreamId.isNotEmpty && re.hasMatch(liveStreamId)) {
      _livestreamIdController.clear();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ILSScreen(liveStreamId: liveStreamId, token: token, mode: mode),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập Livestream ID hợp lệ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: StaffTheme.staffBackground,
      appBar: AppBar(
        title: const Text(
          "Livestream",
          style: TextStyle(fontFamily: "Fredoka", fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tham gia Livestream",
              style: textTheme.titleLarge?.copyWith(
                fontFamily: "Fredoka",
                fontWeight: FontWeight.bold,
                color: StaffTheme.staffPrimary,
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _livestreamIdController,
              style: const TextStyle(
                color: Colors.black87,
                fontFamily: "Nunito",
              ),
              decoration: InputDecoration(
                hintText: 'Nhập Livestream ID',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontFamily: "Nunito",
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.live_tv,
                  color: StaffTheme.staffAccent,
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () => onCreateButtonPressed(context),
              icon: const Icon(Icons.add_circle),
              label: const Text(
                "Tạo Livestream",
                style: TextStyle(fontFamily: "Nunito", fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: StaffTheme.staffPrimary,
              ),
              onPressed: () => onJoinButtonPressed(context, Mode.SEND_AND_RECV),
              icon: const Icon(Icons.videocam),
              label: const Text(
                "Tham gia với vai trò Host",
                style: TextStyle(fontFamily: "Nunito", fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: StaffTheme.staffAccent,
              ),
              onPressed: () => onJoinButtonPressed(context, Mode.RECV_ONLY),
              icon: const Icon(Icons.visibility),
              label: const Text(
                "Tham gia với vai trò Audience",
                style: TextStyle(fontFamily: "Nunito", fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
