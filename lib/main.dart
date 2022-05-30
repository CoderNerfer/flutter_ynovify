import 'package:flutter/material.dart';
import 'package:ynov_ify/music.dart';
import 'package:just_audio/just_audio.dart';

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
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: const Color(0x00A2A2A2)),
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
  String song_duration = "";

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
    await _player.setAudioSource(
        AudioSource.uri(Uri.parse(myMusicList[selectMusic].urlSong)));
    song_duration =
        "${_player.duration!.inMinutes}:${_player.duration!.inSeconds % 60}";
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
              child: Image.asset(myMusicList[selectMusic].imagePath),
            ),
            Text(
              myMusicList[selectMusic].title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              myMusicList[selectMusic].singer,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                song_duration,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
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
                      color: Colors.white,
                      icon: const Icon(Icons.fast_rewind),
                      onPressed: _decrementMusicCounter,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      color: Colors.white,
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
                      color: Colors.white,
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
