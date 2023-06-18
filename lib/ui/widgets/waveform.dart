import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class WaveformScreen extends StatefulWidget {
  @override
  _WaveformScreenState createState() => _WaveformScreenState();
}

class _WaveformScreenState extends State<WaveformScreen> {
  PlayerController controller = PlayerController();
  List<double> waveformData = [];
  PlayerState playerState = PlayerState.stopped;
  final assetPath = 'assets/sounds/sarki1.mp3';

  @override
  void initState() {
    super.initState();
    extractWaveformData();
    controller.onPlayerStateChanged.listen((state) {
      setState(() {
        playerState = state;
      });
    });
  }

  Future<void> extractWaveformData() async {
    final bytes = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/sarki1.mp3';
    final tempFile = await writeToFile(bytes, tempPath);

    await controller.preparePlayer(
      path: tempFile.path,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );

    final extractedData = await controller.extractWaveformData(
      path: tempFile.path,
      noOfSamples: 100,
    );

    setState(() {
      waveformData = extractedData;
    });
  }

  Future<File> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    final file = File(path);
    await file.create(recursive: true);
    await file.writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return file;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AudioFileWaveforms(
          size: Size(200, 100.0),
          playerController: controller,
          enableSeekGesture: true,
          waveformType: WaveformType.long,
          waveformData: waveformData,
          playerWaveStyle: const PlayerWaveStyle(
            fixedWaveColor: Colors.white54,
            liveWaveColor: Colors.blueAccent,
            spacing: 6,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (playerState == PlayerState.playing) {
              await controller.pausePlayer();
            } else {
              await controller.startPlayer(finishMode: FinishMode.stop);
            }
          },
          child: Text(playerState == PlayerState.playing ? 'Pause' : 'Play'),
        ),
      ],
    );
  }
}
