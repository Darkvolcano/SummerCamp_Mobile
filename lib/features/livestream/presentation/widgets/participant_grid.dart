import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:summercamp/features/livestream/presentation/widgets/participant_tile.dart';
import 'package:videosdk/videosdk.dart';

class ParticipantGrid extends StatefulWidget {
  final Room room;
  const ParticipantGrid({super.key, required this.room});

  @override
  State<ParticipantGrid> createState() => _ParticipantGridState();
}

class _ParticipantGridState extends State<ParticipantGrid> {
  late Participant localParticipant;
  int numberOfColumns = 1;
  int maxOnScreenParticipants = 6;

  Map<String, Participant> participants = {};
  Map<String, Participant> onScreenParticipants = {};

  @override
  void initState() {
    super.initState();
    localParticipant = widget.room.localParticipant;
    participants[localParticipant.id] = localParticipant;
    participants.addAll(widget.room.participants);

    updateOnScreenParticipants();
    setLivestreamEventListener(widget.room);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final visibleParticipants = onScreenParticipants.values.toList();

    return Column(
      children: [
        for (
          int i = 0;
          i < (visibleParticipants.length / numberOfColumns).ceil();
          i++
        )
          Expanded(
            child: Row(
              children: [
                for (
                  int j = 0;
                  j <
                      visibleParticipants
                          .sublist(
                            i * numberOfColumns,
                            (i + 1) * numberOfColumns >
                                    visibleParticipants.length
                                ? visibleParticipants.length
                                : (i + 1) * numberOfColumns,
                          )
                          .length;
                  j++
                )
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ParticipantTile(
                        key: Key(
                          visibleParticipants
                              .sublist(
                                i * numberOfColumns,
                                (i + 1) * numberOfColumns >
                                        visibleParticipants.length
                                    ? visibleParticipants.length
                                    : (i + 1) * numberOfColumns,
                              )
                              .elementAt(j)
                              .id,
                        ),
                        participant: visibleParticipants
                            .sublist(
                              i * numberOfColumns,
                              (i + 1) * numberOfColumns >
                                      visibleParticipants.length
                                  ? visibleParticipants.length
                                  : (i + 1) * numberOfColumns,
                            )
                            .elementAt(j),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  void setLivestreamEventListener(Room room) {
    room.on(Events.participantJoined, (Participant participant) {
      final newParticipants = Map<String, Participant>.from(participants);
      newParticipants[participant.id] = participant;
      setState(() {
        participants = newParticipants;
        updateOnScreenParticipants();
      });
    });

    room.on(Events.participantLeft, (String id, _) {
      final newParticipants = Map<String, Participant>.from(participants);
      newParticipants.remove(id);
      setState(() {
        participants = newParticipants;
        updateOnScreenParticipants();
      });
    });

    room.on(Events.participantModeChanged, (_) {
      final newParticipants = <String, Participant>{};
      newParticipants[localParticipant.id] = localParticipant;
      newParticipants.addAll(room.participants);
      setState(() {
        participants = newParticipants;
        updateOnScreenParticipants();
      });
    });

    room.localParticipant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == "share") {
        setState(() {
          maxOnScreenParticipants = 2;
          updateOnScreenParticipants();
        });
      }
    });

    room.localParticipant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == "share") {
        setState(() {
          maxOnScreenParticipants = 6;
          updateOnScreenParticipants();
        });
      }
    });
  }

  void updateOnScreenParticipants() {
    final newScreenParticipants = <String, Participant>{};
    final conferenceParticipants = participants.values
        .where((p) => p.mode == Mode.SEND_AND_RECV)
        .toList();

    conferenceParticipants
        .sublist(
          0,
          conferenceParticipants.length > maxOnScreenParticipants
              ? maxOnScreenParticipants
              : conferenceParticipants.length,
        )
        .forEach((p) => newScreenParticipants[p.id] = p);

    if (!listEquals(
      newScreenParticipants.keys.toList(),
      onScreenParticipants.keys.toList(),
    )) {
      onScreenParticipants = newScreenParticipants;
    }

    final newColumnCount =
        (newScreenParticipants.length > 2 || maxOnScreenParticipants == 2)
        ? 2
        : 1;

    if (numberOfColumns != newColumnCount) {
      numberOfColumns = newColumnCount;
    }
  }
}
