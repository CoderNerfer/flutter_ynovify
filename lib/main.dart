import 'package:flutter/material.dart';
import 'package:ynov_ify/music.dart';
import 'package:just_audio/just_audio.dart';

const Color principal = Color.fromARGB(255, 66, 255, 0);
const Color secondary = Colors.white;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ynovify',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color.fromARGB(255, 33, 33, 33),
      ),
      home: const MyHomePage(title: 'Ynovify'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool selected = true;
  int selectMusic = 0;
  String songduration = "";

  List<Music> myMusicList = [
    Music(
        'Dynasties and Dystopia',
        'Danzel Curry',
        'assets/img/Arcane-photo.jpeg',
        'https://music.florian-berthier.com/Dynasties%20and%20Dystopia%20-%20Danzel%20Curry.mp3'),
    Music(
        'Get Jinxed',
        'League of Legends',
        'assets/img/League of Legends.jpeg',
        'https://music.florian-berthier.com/Get%20Jinxed%20-%20League%20of%20Legends.mp3'),
    Music('Enemy', 'Imagine Dragons', 'assets/img/Arcane.jpeg',
        'https://music.florian-berthier.com/Enemy%20-%20Imagine%20Dragons.mp3'),
  ];

  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _init(selectMusic);
  }

  void _incrementMusicCounter() {
    setState(() {
      (selectMusic == myMusicList.length - 1) ? selectMusic = 0 : selectMusic++;
    });
    _init(selectMusic);
  }

  void _decrementMusicCounter() {
    setState(() {
      (selectMusic == 0) ? selectMusic = myMusicList.length - 1 : selectMusic--;
    });
    _init(selectMusic);
  }

  Future<void> _init(int selectMusic) async {
    await _player
        .setAudioSource(
            AudioSource.uri(Uri.parse(myMusicList[selectMusic].urlSong)))
        .then((value) => {
              setState(() {
                songduration = "${value!.inMinutes}:${value.inSeconds % 60}";
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(50),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: secondary, width: 1),
                  ),
                  child: Image.asset(myMusicList[selectMusic].imagePath),
                )
                // child: Image.asset(myMusicList[selectMusic].imagePath),
                ),
            Text(
              myMusicList[selectMusic].title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: secondary,
              ),
            ),
            Text(
              myMusicList[selectMusic].singer,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                songduration,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: secondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      color: principal,
                      icon: const Icon(Icons.fast_rewind),
                      onPressed: _decrementMusicCounter,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      color: principal,
                      icon: Icon(selected ? Icons.play_arrow : Icons.pause),
                      onPressed: () {
                        setState(() {
                          selected = !selected;
                          (selected ? _player.pause() : _player.play());
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      color: principal,
                      icon: const Icon(Icons.fast_forward),
                      onPressed: _incrementMusicCounter,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
