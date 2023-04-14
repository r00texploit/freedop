import 'package:audioplayers/audioplayers.dart';
import '../components/player_widget.dart';
import '../components/properties_widget.dart';
import '../components/stream_widget.dart';
import '../components/tab_content.dart';
import 'package:flutter/material.dart';

class StreamsTab extends StatelessWidget {
  final AudioPlayer player;

  const StreamsTab({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return TabContent(
      children: [
        PlayerWidget(player: player),
        const Divider(),
        StreamWidget(player: player),
        const Divider(),
        PropertiesWidget(player: player),
      ],
    );
  }
}
