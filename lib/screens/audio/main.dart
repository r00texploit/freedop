import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:today/screens/audio/components/indexed_stack.dart';
import 'package:today/screens/audio/components/tabs.dart';
import 'package:today/screens/audio/tabs/sources.dart';
import 'package:today/screens/audio/utils.dart';

const defaultPlayerCount = 4;

typedef OnError = void Function(Exception exception);

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  List<AudioPlayer> audioPlayers = List.generate(
    defaultPlayerCount,
    (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop),
  );
  int selectedPlayerIdx = 0;

  AudioPlayer get selectedAudioPlayer => audioPlayers[selectedPlayerIdx];
  List<StreamSubscription> streams = [];

  @override
  void initState() {
    super.initState();
    audioPlayers.asMap().forEach((index, player) {
      streams.add(
        player.onPlayerStateChanged.listen(
          (it) {
            switch (it) {
              case PlayerState.stopped:
                toast(
                  'Player stopped!',
                  textKey: Key('toast-player-stopped-$index'),
                );
                break;
              case PlayerState.completed:
                toast(
                  'Player complete!',
                  textKey: Key('toast-player-complete-$index'),
                );
                break;
              default:
                break;
            }
          },
        ),
      );
      streams.add(
        player.onSeekComplete.listen(
          (it) => toast(
            'Seek complete!',
            textKey: Key('toast-seek-complete-$index'),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    streams.forEach((it) => it.cancel());
    super.dispose();
  }

  void _handleAction(PopupAction value) {
    switch (value) {
      case PopupAction.add:
        setState(() {
          audioPlayers.add(AudioPlayer()..setReleaseMode(ReleaseMode.stop));
        });
        break;
      case PopupAction.remove:
        setState(() {
          if (audioPlayers.isNotEmpty) {
            selectedAudioPlayer.stop();
            selectedAudioPlayer.release();
            audioPlayers.removeAt(selectedPlayerIdx);
          }

          if (audioPlayers.isEmpty) {
            selectedPlayerIdx = 0;
          } else if (selectedPlayerIdx >= audioPlayers.length) {
            selectedPlayerIdx = audioPlayers.length - 1;
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: audioPlayers.isEmpty
                ? const Text('No AudioPlayer available!')
                : IndexedStack2(
                    index: selectedPlayerIdx,
                    children: audioPlayers
                        .map(
                          (player) => Tabs(
                            key: GlobalObjectKey(player),
                            tabs: [
                              TabData(
                                key: 'sourcesTab',
                                label: 'PlayList',
                                content: SourcesTab(
                                  player: player,
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

enum PopupAction {
  add,
  remove,
}
