import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:today/audio/components/player_widget.dart';
import 'package:today/controller/audio_controller.dart';
import 'package:today/pages/api/firebase_api.dart';
import '../components/tab_content.dart';
import '../utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

const useLocalServer = bool.fromEnvironment('USE_LOCAL_SERVER');

final localhost = kIsWeb || !Platform.isAndroid ? 'localhost' : '10.0.2.2';
final host = useLocalServer ? 'http://$localhost:8080' : 'https://luan.xyz';

final wavUrl1 = '$host/files/audio/coins.wav';
final wavUrl2 = '$host/files/audio/laser.wav';
final mp3Url1 = '$host/files/audio/ambient_c_motion.mp3';
final mp3Url2 = '$host/files/audio/nasa_on_a_mission.mp3';
final m3u8StreamUrl = useLocalServer
    ? '$host/files/live_streams/nasa_power_of_the_rovers.m3u8'
    : 'https://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/hls/nonuk/sbr_low/ak/bbc_radio_one.m3u8';
const mpgaStreamUrl = 'https://timesradio.wireless.radio/stream';

const asset1 = 'laser.wav';
const asset2 = 'nasa_on_a_mission.mp3';

class SourcesTab extends StatefulWidget {
  final AudioPlayer player;

  const SourcesTab({super.key, required this.player});

  @override
  State<SourcesTab> createState() => _SourcesTabState();
}

class _SourcesTabState extends State<SourcesTab>
    with AutomaticKeepAliveClientMixin<SourcesTab> {
  AudioPlayer get player => widget.player;

  Future<void> _setSource(Source source) async {
    await player.setSource(source);
    toast(
      'Completed setting source.',
      textKey: const Key('toast-set-source'),
    );
  }

  _download(String? name, String? url) async {
    final dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/${name}');
    log("message file:${file.path}");
    log("message:$url");
    var ref = FirebaseStorage.instance.refFromURL(url!);
    await ref.writeToFile(file);
    final snackBar = SnackBar(
      content: Text('Downloaded ${name}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _play(Source source) async {
    await player.stop();
    await player.play(source);
    log("message:${source.toString()}");
    toast(
      'Set and playing source.',
      textKey: const Key('toast-set-play'),
    );
  }

  Widget _createSourceTile({
    required String title,
    required String subtitle,
    required Source source,
    Key? setSourceKey,
    Key? playKey,
  }) =>
      _SourceTile(
        download: () => _download(title,
            source.toString().substring(15, source.toString().length - 1)),
        play: () => _play(source),
        title: title,
        subtitle: subtitle,
        setSourceKey: setSourceKey,
        playKey: playKey,
      );

  Future<void> _setSourceBytesAsset(
    Future<void> Function(Source) fun, {
    required String asset,
  }) async {
    final bytes = await AudioCache.instance.loadAsBytes(asset);
    await fun(BytesSource(bytes));
  }

  Future<void> _setSourceBytesRemote(
    Future<void> Function(Source) fun, {
    required String url,
  }) async {
    final bytes = await readBytes(Uri.parse(url));
    await fun(BytesSource(bytes));
  }

  Future<void> _setSourceFilePicker(Future<void> Function(Source) fun) async {
    final result = await FilePicker.platform.pickFiles();
    final path = result?.files.single.path;
    if (path != null) {
      _setSource(DeviceFileSource(path));
    }
  }

  // getAudioFromFireStore(){

  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    super.build(context);
    return GetX<AudiosController>(
        // autoRemove: false,
        init: AudiosController(),
        builder: (controller) {
          if (controller.audios.isEmpty) {
            return const Center(child: Text('No Audios Founded'));
          } else {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Expanded(
                  child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 270,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(colors: [
                            // Color.fromARGB(255, 24, 94, 224),
                            Color(0xFF42A5F5),
                            Color.fromARGB(15, 42, 197, 244),
                          ])
                          // color: Colors.amber,
                          ),
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                left: 15,
                                top: 20,
                                bottom: 5,
                              ),
                              child: _createSourceTile(
                                setSourceKey: Key(controller.audios[index].url!),
                                title: controller.audios[index].name!,
                                subtitle: controller.audios[index].name!,
                                source: UrlSource(controller.audios[index].url!),
                              )),
                        Visibility(
                          visible: true,
                          child: PlayerWidget(player: player)),
                
                        ],
                      )),
                );
              },
              itemCount: controller.audios.length,
            );
          }
        });
    // ,
    // _createSourceTile(
    //   setSourceKey: const Key('setSource-url-remote-wav-2'),
    //   title: 'Remote URL WAV 2',
    //   subtitle: 'laser.wav',
    //   source: UrlSource(wavUrl2),
    // ),
    // _createSourceTile(
    //   setSourceKey: const Key('setSource-url-remote-mp3-1'),
    //   title: 'Remote URL MP3 1',
    //   subtitle: 'ambient_c_motion.mp3',
    //   source: UrlSource(mp3Url1),
    // ),
    // _createSourceTile(
    //   setSourceKey: const Key('setSource-url-remote-mp3-2'),
    //   title: 'Remote URL MP3 2',
    //   subtitle: 'nasa_on_a_mission.mp3',
    //   source: UrlSource(mp3Url2),
    // ),
    // _createSourceTile(
    //   setSourceKey: const Key('setSource-url-remote-m3u8'),
    //   title: 'Remote URL M3U8',
    //   subtitle: 'BBC stream',
    //   source: UrlSource(m3u8StreamUrl),
    // ),
    // _createSourceTile(
    //   setSourceKey: const Key('setSource-url-remote-mpga'),
    //   title: 'Remote URL MPGA',
    //   subtitle: 'Times stream',
    //   source: UrlSource(mpgaStreamUrl),
    // ),
    // _createSourceTile(
    //   setSourceKey: const Key('setSource-asset-wav'),
    //   title: 'Asset 1',
    //   subtitle: 'laser.wav',
    //   source: AssetSource(asset1),
    // ),
    // _createSourceTile(
    //   setSourceKey: const Key('setSource-asset-mp3'),
    //   title: 'Asset 2',
    //   subtitle: 'nasa.mp3',
    //   source: AssetSource(asset2),
    // ),
    // _SourceTile(
    //   setSource: () => _setSourceBytesAsset(_setSource, asset: asset1),
    //   setSourceKey: const Key('setSource-bytes-local'),
    //   play: () => _setSourceBytesAsset(_play, asset: asset1),
    //   title: 'Bytes - Local',
    //   subtitle: 'laser.wav',
    // ),
    // _SourceTile(
    //   setSource: () => _setSourceBytesRemote(_setSource, url: mp3Url1),
    //   setSourceKey: const Key('setSource-bytes-remote'),
    //   play: () => _setSourceBytesRemote(_play, url: mp3Url1),
    //   title: 'Bytes - Remote',
    //   subtitle: 'ambient.mp3',
    // ),
    // _SourceTile(
    //   setSource: () => _setSourceFilePicker(_setSource),
    //   setSourceKey: const Key('setSource-url-local'),
    //   play: () => _setSourceFilePicker(_play),
    //   title: 'Device File',
    //   subtitle: 'Pick local file from device',
    // ),
    //   ],
    // );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SourceTile extends StatelessWidget {
  final void Function() download;
  final void Function() play;
  final String title;
  final String? subtitle;
  final Key? setSourceKey;
  final Key? playKey;

  const _SourceTile({
    required this.download,
    required this.play,
    required this.title,
    this.subtitle,
    this.setSourceKey,
    this.playKey,
  });

  @override
  Widget build(BuildContext context) {
    var len = title.length;
    return ListTile(
      title: Text(title.substring(0, len>30? 15 : 10)),
      // subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Set Source',
            key: setSourceKey,
            onPressed: download,
            icon: const Icon(Icons.download_for_offline_outlined),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            key: playKey,
            tooltip: 'Play',
            onPressed: play,
            icon: const Icon(Icons.play_arrow),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
