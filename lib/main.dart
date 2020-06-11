import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentTime = "00:00";
  String completeTime = "00:00";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().split(".")[0];
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Audio Player",
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 60,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.5,
              left: MediaQuery.of(context).size.width * 0.1,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.fast_rewind,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {
                    _audioPlayer.seek(
                      Duration(
                        milliseconds: 1200,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: currentTime == completeTime
                      ? Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 25,
                        )
                      : Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 25,
                        ),
                  onPressed: () {
                    if (isPlaying) {
                      _audioPlayer.pause();

                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      _audioPlayer.resume();

                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.fast_forward,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {
//                    _audioPlayer.seek(
//                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.stop,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {
                    _audioPlayer.stop();

                    setState(() {
                      isPlaying = false;
                    });

                    setState(() {
                      currentTime = "00:00";
                    });
                  },
                ),
                Text(
                  currentTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                  ),
                ),
                Text(
                  "|",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                  ),
                ),
                Text(
                  completeTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String filePath = await FilePicker.getFilePath(
            type: FileType.audio,
          );

          int status = await _audioPlayer.play(
            filePath,
            isLocal: true,
          );

          if (status == 1) {
            setState(() {
              isPlaying = true;
            });
            print("Button Clicked");
          }
        },
        child: IconButton(
          icon: Icon(
            Icons.audiotrack,
          ),
        ),
      ),
    );
  }
}
