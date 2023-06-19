import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_app/app/configs/colors.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _HomeState();
}

class _HomeState extends State<RecordPage> {
  late final RecorderController recorderController;

  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
    isLoading = false;
    setState(() {});
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      musicFile = result.files.single.path;
      setState(() {});
    } else {
      debugPrint("File not picked");
    }
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  if (isRecordingCompleted)
                    Text(
                      'Recorded File Path: $path',
                      style: TextStyle(color: Colors.white),
                    ),
                  if (musicFile != null)
                    Text(
                      'Music File Path: $musicFile',
                      style: TextStyle(color: Colors.white),
                    ),
                  SafeArea(
                    child: Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isRecording
                              ? AudioWaveforms(
                                  enableGesture: true,
                                  size: Size(
                                      MediaQuery.of(context).size.width / 2,
                                      50),
                                  recorderController: recorderController,
                                  waveStyle: const WaveStyle(
                                    waveColor: Colors.white,
                                    extendWaveform: true,
                                    showMiddleLine: false,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: AppColors.primaryColor2,
                                  ),
                                  padding: const EdgeInsets.only(left: 18),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.7,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor2,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  padding: const EdgeInsets.only(left: 18),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: "Record Something...",
                                      hintStyle: const TextStyle(
                                          color: Colors.white54),
                                      contentPadding:
                                          const EdgeInsets.only(top: 16),
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        onPressed: _pickFile,
                                        icon: Icon(Icons.adaptive.share),
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        IconButton(
                          onPressed: _refreshWave,
                          icon: Icon(
                            isRecording ? Icons.refresh : Icons.send,
                            color: AppColors.primaryColor2,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _startOrStopRecording,
                          icon: Icon(isRecording ? Icons.stop : Icons.mic),
                          color: AppColors.primaryColor2,
                          iconSize: 28,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _startOrStopRecording() async {
    try {
      if (isRecording) {
        recorderController.reset();

        final recordedPath = await recorderController.stop();

        if (recordedPath != null) {
          isRecordingCompleted = true;
          path = recordedPath;
          debugPrint("Recorded file path: $path");
          debugPrint("Recorded file size: ${File(path!).lengthSync()}");
        }
      } else {
        await recorderController.record(path: path!);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }
}
