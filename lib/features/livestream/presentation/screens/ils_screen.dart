import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';
import 'ils_view.dart';
import 'join_screen.dart';

class ILSScreen extends StatefulWidget {
  final String liveStreamId;
  final String token;
  final Mode mode;

  const ILSScreen({
    super.key,
    required this.liveStreamId,
    required this.token,
    required this.mode,
  });

  @override
  State<ILSScreen> createState() => _ILSScreenState();
}

class _ILSScreenState extends State<ILSScreen> {
  late Room _room;
  bool isJoined = false;
  Mode? localParticipantMode;

  @override
  void initState() {
    super.initState();
    _room = VideoSDK.createRoom(
      roomId: widget.liveStreamId,
      token: widget.token,
      displayName: "John Doe",
      micEnabled: false,
      camEnabled: false,
      defaultCameraIndex: 1,
      mode: widget.mode,
    );
    localParticipantMode = widget.mode;
    setLivestreamEventListener();
    _room.join();
  }

  void setLivestreamEventListener() {
    _room.on(Events.roomJoined, () {
      if (widget.mode == Mode.SEND_AND_RECV) {
        _room.localParticipant.pin();
      }
      setState(() {
        localParticipantMode = _room.localParticipant.mode;
        isJoined = true;
      });
    });

    _room.on(Events.roomLeft, () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => JoinScreen()),
        (route) => false,
      );
    });
  }

  Future<bool> _onWillPop() async {
    _room.leave();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _onWillPop();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: isJoined
            ? ILSView(room: _room, bar: false, mode: widget.mode)
            : const Center(
                child: Text(
                  "Joining...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
