import 'package:flutter/material.dart';
import 'package:wo_read/hair/models/character_data.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MoviePage extends StatefulWidget {
  final CharacterKey characterKey;
  const MoviePage({super.key, required this.characterKey});

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late List<YoutubePlayerController> _controllers;

  @override
  void initState() {
    super.initState();
    final List<String>? videoIds = MovieId[widget.characterKey];
    _controllers = (videoIds ?? [])
        .map(
          (String id) => YoutubePlayerController(
            initialVideoId: id,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: true,
              enableCaption: true,
            ),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    for (YoutubePlayerController controller in _controllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YouTube Video Player')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: _controllers
                .map(
                  (controller) => Card(
                    child: YoutubePlayer(
                      controller: controller,
                      showVideoProgressIndicator: true,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
