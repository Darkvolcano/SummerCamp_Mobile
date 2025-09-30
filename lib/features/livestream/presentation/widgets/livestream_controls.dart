import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

class LivestreamControls extends StatefulWidget {
  final Mode mode;
  final void Function()? onToggleMicButtonPressed;
  final void Function()? onToggleCameraButtonPressed;
  final void Function()? onChangeModeButtonPressed;
  final void Function()? onLeaveButtonPressed;

  const LivestreamControls({
    super.key,
    required this.mode,
    this.onToggleMicButtonPressed,
    this.onToggleCameraButtonPressed,
    this.onChangeModeButtonPressed,
    this.onLeaveButtonPressed,
  });

  @override
  State<LivestreamControls> createState() => _LivestreamControlsState();
}

class _LivestreamControlsState extends State<LivestreamControls> {
  bool isMicOn = false;
  bool isCameraOn = false;
  bool isMicLoading = false;
  bool isCameraLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.mode == Mode.SEND_AND_RECV) ...[
            // Leave Button
            _buildControlButton(
              icon: Icons.call_end_rounded,
              backgroundColor: Colors.red,
              isLoading: false,
              onPressed: widget.onLeaveButtonPressed,
            ),

            const SizedBox(width: 12),

            // Mic Button
            _buildControlButton(
              icon: isMicOn ? Icons.mic : Icons.mic_off,
              backgroundColor: isMicOn ? Colors.white : const Color(0xFF3A3A3C),
              iconColor: isMicOn ? Colors.black : Colors.white,
              isLoading: isMicLoading,
              onPressed: () async {
                if (isMicLoading) return;

                setState(() {
                  isMicLoading = true;
                });

                try {
                  widget.onToggleMicButtonPressed?.call();
                  await Future.delayed(const Duration(milliseconds: 300));

                  if (mounted) {
                    setState(() {
                      isMicOn = !isMicOn;
                      isMicLoading = false;
                    });
                  }
                } catch (e) {
                  if (mounted) {
                    setState(() {
                      isMicLoading = false;
                    });
                  }
                }
              },
            ),

            const SizedBox(width: 12),

            // Camera Button
            _buildControlButton(
              icon: isCameraOn ? Icons.videocam : Icons.videocam_off,
              backgroundColor: isCameraOn
                  ? Colors.white
                  : const Color(0xFF3A3A3C),
              iconColor: isCameraOn ? Colors.black : Colors.white,
              isLoading: isCameraLoading,
              onPressed: () async {
                if (isCameraLoading) return;

                setState(() {
                  isCameraLoading = true;
                });

                try {
                  widget.onToggleCameraButtonPressed?.call();
                  await Future.delayed(const Duration(milliseconds: 500));

                  if (mounted) {
                    setState(() {
                      isCameraOn = !isCameraOn;
                      isCameraLoading = false;
                    });
                  }
                } catch (e) {
                  if (mounted) {
                    setState(() {
                      isCameraLoading = false;
                    });
                  }
                }
              },
            ),
            const SizedBox(width: 12),
            // More Options Button
            _buildControlButton(
              icon: Icons.more_horiz,
              backgroundColor: const Color(0xFF3A3A3C),
              iconColor: Colors.white,
              isLoading: false,
              onPressed: () {
                // Show more options menu
              },
            ),
          ] else if (widget.mode == Mode.RECV_ONLY) ...[
            // Leave Button
            _buildControlButton(
              icon: Icons.call_end_rounded,
              backgroundColor: Colors.red,
              isLoading: false,
              onPressed: widget.onLeaveButtonPressed,
            ),
            const SizedBox(width: 12),
            // Join as Host Button
            _buildControlButton(
              icon: Icons.person,
              backgroundColor: Colors.green,
              isLoading: false,
              onPressed: widget.onChangeModeButtonPressed,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color backgroundColor,
    Color iconColor = Colors.white,
    required bool isLoading,
    bool showDropdown = false,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: iconColor,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Icon(icon, color: iconColor, size: 24),
              if (showDropdown) ...[
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: iconColor, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:videosdk/videosdk.dart';

// class LivestreamControls extends StatefulWidget {
//   final Mode mode;
//   final void Function()? onToggleMicButtonPressed;
//   final void Function()? onToggleCameraButtonPressed;
//   final void Function()? onChangeModeButtonPressed;
//   final void Function()? onLeaveButtonPressed;

//   const LivestreamControls({
//     super.key,
//     required this.mode,
//     this.onToggleMicButtonPressed,
//     this.onToggleCameraButtonPressed,
//     this.onChangeModeButtonPressed,
//     this.onLeaveButtonPressed,
//   });

//   @override
//   State<LivestreamControls> createState() => _LivestreamControlsState();
// }

// class _LivestreamControlsState extends State<LivestreamControls> {
//   bool isMicOn = false;
//   bool isCameraOn = false;
//   bool isMicLoading = false;
//   bool isCameraLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.black.withValues(alpha: 0.7),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (widget.mode == Mode.SEND_AND_RECV) ...[
//             // Mic Button
//             _buildControlButton(
//               icon: isMicOn ? Icons.mic : Icons.mic_off,
//               label: isMicOn ? 'Mic On' : 'Mic Off',
//               backgroundColor: isMicOn ? Colors.blue : Colors.red,
//               isLoading: isMicLoading,
//               onPressed: () async {
//                 if (isMicLoading) return;

//                 setState(() {
//                   isMicLoading = true;
//                 });

//                 try {
//                   widget.onToggleMicButtonPressed?.call();
//                   await Future.delayed(const Duration(milliseconds: 300));

//                   if (mounted) {
//                     setState(() {
//                       isMicOn = !isMicOn;
//                       isMicLoading = false;
//                     });
//                   }
//                 } catch (e) {
//                   if (mounted) {
//                     setState(() {
//                       isMicLoading = false;
//                     });
//                   }
//                 }
//               },
//             ),
//             const SizedBox(width: 16),
//             // Camera Button
//             _buildControlButton(
//               icon: isCameraOn ? Icons.videocam : Icons.videocam_off,
//               label: isCameraOn ? 'Cam On' : 'Cam Off',
//               backgroundColor: isCameraOn ? Colors.blue : Colors.red,
//               isLoading: isCameraLoading,
//               onPressed: () async {
//                 if (isCameraLoading) return;

//                 setState(() {
//                   isCameraLoading = true;
//                 });

//                 try {
//                   widget.onToggleCameraButtonPressed?.call();
//                   await Future.delayed(const Duration(milliseconds: 500));

//                   if (mounted) {
//                     setState(() {
//                       isCameraOn = !isCameraOn;
//                       isCameraLoading = false;
//                     });
//                   }
//                 } catch (e) {
//                   if (mounted) {
//                     setState(() {
//                       isCameraLoading = false;
//                     });
//                   }
//                 }
//               },
//             ),
//             const SizedBox(width: 16),
//             // Leave Button
//             _buildControlButton(
//               icon: Icons.call_end,
//               label: 'Leave',
//               backgroundColor: Colors.red.shade700,
//               isLoading: false,
//               onPressed: widget.onLeaveButtonPressed,
//             ),
//           ] else if (widget.mode == Mode.RECV_ONLY) ...[
//             // Change to Host/Speaker Mode
//             _buildControlButton(
//               icon: Icons.person,
//               label: 'Host/Speaker',
//               backgroundColor: Colors.green,
//               isLoading: false,
//               onPressed: widget.onChangeModeButtonPressed,
//             ),
//             const SizedBox(width: 16),
//             // Leave Button
//             _buildControlButton(
//               icon: Icons.call_end,
//               label: 'Leave',
//               backgroundColor: Colors.red.shade700,
//               isLoading: false,
//               onPressed: widget.onLeaveButtonPressed,
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildControlButton({
//     required IconData icon,
//     required String label,
//     required Color backgroundColor,
//     required bool isLoading,
//     required VoidCallback? onPressed,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Material(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(50),
//           child: InkWell(
//             onTap: isLoading ? null : onPressed,
//             borderRadius: BorderRadius.circular(50),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               child: isLoading
//                   ? const SizedBox(
//                       width: 28,
//                       height: 28,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 3,
//                       ),
//                     )
//                   : Icon(icon, color: Colors.white, size: 28),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
