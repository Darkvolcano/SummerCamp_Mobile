import 'package:flutter/material.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:videosdk/videosdk.dart';

class ParticipantTile extends StatefulWidget {
  final Participant participant;
  const ParticipantTile({super.key, required this.participant});

  @override
  State<ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<ParticipantTile> {
  Stream? videoStream;
  Stream? audioStream;

  @override
  void initState() {
    super.initState();
    _initStreamListeners();

    widget.participant.streams.forEach((_, stream) {
      if (stream.kind == "video") videoStream = stream;
      if (stream.kind == "audio") audioStream = stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(widget.participant.displayName);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: StaffTheme.staffAccent, width: 1.5),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: videoStream != null
                ? RTCVideoView(
                    videoStream?.renderer as RTCVideoRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  )
                : Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: StaffTheme.staffAccent,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ),

          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.participant.displayName,
                    style: const TextStyle(
                      fontFamily: "Quicksand",
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(width: 6),

                  if (audioStream != null)
                    const Icon(Icons.mic, color: Colors.white, size: 14)
                  else
                    const Icon(Icons.mic_off, color: Colors.red, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initStreamListeners() {
    widget.participant.on(Events.streamEnabled, (Stream stream) {
      setState(() {
        if (stream.kind == "video") videoStream = stream;
        if (stream.kind == "audio") audioStream = stream;
      });
    });

    widget.participant.on(Events.streamDisabled, (Stream stream) {
      setState(() {
        if (stream.kind == "video") videoStream = null;
        if (stream.kind == "audio") audioStream = null;
      });
    });
  }

  String _getInitials(String name) {
    final parts = name.trim().split(" ");
    if (parts.isEmpty) return "?";
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
