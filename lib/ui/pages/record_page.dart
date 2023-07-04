import 'dart:convert';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_app/app/configs/colors.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../app/configs/theme.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _HomeState();
}

class _HomeState extends State<RecordPage> {
  late final RecorderController recorderController;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final TextEditingController _naming = TextEditingController();

  late String? path;
  late String? path2;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
    //CollectionReference recordingsRef = fireStore.collection('Recordings');
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
    path2 = "${appDirectory.path}/recording2.m4a";
    isLoading = false;
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
    _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24,
            color: AppColors.blackColor,
          ),
        ),
        title: Text(
          'Record Audio',
          style: AppTheme.blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: AppTheme.bold,
          ),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  SafeArea(
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 230, 230, 230),
                              border: Border.all(color: AppColors.whiteColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 50,
                            width: 270,
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _naming,
                                    decoration: const InputDecoration(
                                        hintText: "Name your recording...",
                                        border: InputBorder
                                            .none //OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 45),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isRecording
                              ? AudioWaveforms(
                                  enableGesture: true,
                                  size: Size(
                                      MediaQuery.of(context).size.width,

                                      /// 2,
                                      70),
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
                                      horizontal: 28),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width, //1.7,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor2,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  padding: const EdgeInsets.only(left: 18),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 28),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextField(
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          hintText: "Record Something...",
                                          hintStyle: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white54),
                                          border: InputBorder.none,
                                          suffixIcon: IconButton(
                                            onPressed: _pickFile,
                                            icon: Icon(Icons.adaptive.share),
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 225,
                          width: 225,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor2.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryColor2.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(200),
                                ),
                                height: 160,
                                width: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor2,
                                        /*gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColors.primaryColor2,
                                              Color.fromARGB(255, 126, 87, 223),
                                            ]),*/
                                        //color: Color.fromARGB(255, 202, 146, 228),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      width: 110,
                                      height: 110,
                                      child: IconButton(
                                        onPressed: _startOrStopRecording,
                                        icon: Icon(isRecording
                                            ? Icons.stop
                                            : Icons.mic),
                                        color: AppColors.whiteColor,
                                        iconSize: 65,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        StreamBuilder<int>(
                          stream: _stopWatchTimer.rawTime,
                          initialData: _stopWatchTimer.rawTime.value,
                          builder: (context, snapshot) {
                            final value = snapshot.data;
                            final displayTime = StopWatchTimer.getDisplayTime(
                                value!,
                                hours: _isHours);

                            return Text(displayTime,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 34,
                                    color: AppColors.primaryColor2
                                        .withOpacity(0.5)));
                          },
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

        _stopWatchTimer.onStopTimer();
        _stopWatchTimer.onResetTimer(); //stop
        final recordedPath = await recorderController.stop();

        if (recordedPath != null) {
          isRecordingCompleted = true;
          path = recordedPath;
          File file = File(path!);

          CollectionReference recordingsRef =
              fireStore.collection('recordings');
          Map<String, dynamic> data = {
            'audio': base64Encode(file.readAsBytesSync()),
            'sender': auth.currentUser!.email,
            'name': _naming.text,
            'senderId': auth.currentUser!.uid,
          };

          await recordingsRef
              .doc(auth.currentUser!.uid)
              .collection('audio')
              .add(data);

          await recordingsRef
              .doc(auth.currentUser!.uid)
              .collection('audio')
              .get()
              .then((value) {
            print(value.docs[0].data()['audio']);
          });
        }
      } else {
        _stopWatchTimer.onStartTimer(); //start timer
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
    _stopWatchTimer.onResetTimer();
  }
}
