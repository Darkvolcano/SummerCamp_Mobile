import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/features/livestream/presentation/widgets/livestream_controls.dart';
import 'package:summercamp/features/livestream/presentation/widgets/participant_grid.dart';
import 'package:videosdk/videosdk.dart';

class ILSView extends StatefulWidget {
  final Room room;
  final Mode mode;
  final bool bar;
  const ILSView({
    super.key,
    required this.room,
    required this.bar,
    required this.mode,
  });

  @override
  State<ILSView> createState() => _ILSViewState();
}

class _ILSViewState extends State<ILSView> {
  var micEnabled = false;
  var camEnabled = false;

  Map<String, Participant> participants = {};
  Mode? localMode;
  VideoDeviceInfo? selectedCam;

  @override
  void initState() {
    super.initState();
    localMode = widget.mode;
    setLivestreamEventListener();
    participants.putIfAbsent(
      widget.room.localParticipant.id,
      () => widget.room.localParticipant,
    );
    for (var participant in widget.room.participants.values) {
      if (participant.mode == Mode.SEND_AND_RECV) {
        participants.putIfAbsent(participant.id, () => participant);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: StaffTheme.staffBackground,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: StaffTheme.staffPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Room ID: ${widget.room.id}",
                          style: textTheme.bodyMedium?.copyWith(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 16,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${participants.length} ${participants.length == 1 ? 'participant' : 'participants'}",
                              style: textTheme.bodySmall?.copyWith(
                                fontFamily: "Quicksand",
                                color: Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: StaffTheme.staffPrimary,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.room.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Livestream ID Copied")),
                      );
                    },
                  ),
                ],
              ),
            ),

            Expanded(child: ParticipantGrid(room: widget.room)),

            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildLivestreamControls(textTheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLivestreamControls(TextTheme textTheme) {
    if (localMode == Mode.SEND_AND_RECV) {
      return LivestreamControls(
        mode: Mode.SEND_AND_RECV,
        onToggleMicButtonPressed: () async {
          micEnabled ? widget.room.muteMic() : widget.room.unmuteMic();
          setState(() {
            micEnabled = !micEnabled;
          });
        },
        onToggleCameraButtonPressed: () async {
          camEnabled ? widget.room.disableCam() : widget.room.enableCam();
          setState(() {
            camEnabled = !camEnabled;
          });
        },
        onChangeModeButtonPressed: () {
          widget.room.changeMode(Mode.RECV_ONLY);
          setState(() {
            localMode = Mode.RECV_ONLY;
          });
        },
        onLeaveButtonPressed: () {
          widget.room.leave();
        },
        onFlipCameraButtonPressed: () async {
          final List<VideoDeviceInfo>? cameras =
              await VideoSDK.getVideoDevices();

          if (!mounted) return;

          if (cameras == null || cameras.length < 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Không thể đổi camera")),
            );
            return;
          }

          selectedCam ??= cameras.first;

          // Find camera dirrent with camera choosen
          final newCam = cameras.firstWhere(
            (cam) => cam.deviceId != selectedCam?.deviceId,
            orElse: () => cameras.first,
          );

          widget.room.changeCam(newCam);

          setState(() {
            selectedCam = newCam;
          });
        },
      );
    } else {
      return LivestreamControls(
        mode: Mode.RECV_ONLY,
        onChangeModeButtonPressed: () {
          widget.room.changeMode(Mode.SEND_AND_RECV);
          setState(() {
            localMode = Mode.SEND_AND_RECV;
          });
        },
        onLeaveButtonPressed: () {
          widget.room.leave();
        },
      );
    }
  }

  void setLivestreamEventListener() {
    widget.room.on(Events.participantJoined, (Participant participant) {
      if (participant.mode == Mode.SEND_AND_RECV) {
        setState(() => participants[participant.id] = participant);
      }
    });

    widget.room.on(Events.participantLeft, (
      String participantId,
      Map<String, dynamic> reason,
    ) {
      if (participants.containsKey(participantId)) {
        setState(() => participants.remove(participantId));
      }
    });

    widget.room.on(Events.participantModeChanged, (_) {
      setState(() {});
    });
  }
}
