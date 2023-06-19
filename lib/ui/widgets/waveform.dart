import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

import 'package:social_media_app/app/configs/colors.dart';

class WaveformScreen extends StatefulWidget {
  @override
  _WaveformScreenState createState() => _WaveformScreenState();
}

class _WaveformScreenState extends State<WaveformScreen> {
  PlayerController controller = PlayerController();
  List<double> waveformData = [];
  PlayerState playerState = PlayerState.stopped;
  final assetPath = 'assets/sounds/enver.mp3';

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
    final tempPath = '${tempDir.path}/enver.mp3';
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(20, 60),
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 188, 96, 228),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          onPressed: () async {
            if (playerState == PlayerState.playing) {
              await controller.pausePlayer();
            } else {
              await controller.startPlayer(finishMode: FinishMode.stop);
            }
          },
          child: Icon(
            playerState == PlayerState.playing ? Icons.pause : Icons.play_arrow,
            size: 30,
          ),
        ),
        AudioFileWaveforms(
          size: const Size(200.0, 100.0),
          playerController: controller,
          enableSeekGesture: true,
          waveformType: WaveformType.fitWidth,
          waveformData: waveformData,
          playerWaveStyle: const PlayerWaveStyle(
            fixedWaveColor: Colors.white54,
            liveWaveColor: Colors.white,
            spacing: 6,
          ),
        ),
      ],
    );
  }
}
