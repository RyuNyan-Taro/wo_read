import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late List<YoutubePlayerController> _controllers;

  static const List<String> videoIds = ['NRcTvCXj5y0', 'V6lOXWYf5QU'];

  @override
  void initState() {
    super.initState();
    _controllers = videoIds
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

    @override
    void initState() {
      super.initState();
      _controllers = videoIds
          .map(
            (String id) => YoutubePlayerController(
              initialVideoId: id,
              flags: const YoutubePlayerFlags(
                autoPlay: true,
                mute: true,
                enableCaption: true,
              ),
            ),
          )
          .toList();
    }

    for (YoutubePlayerController controller in _controllers) {
      print(controller.metadata);
    }
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
        child: Column(
          children: _controllers
              .map(
                (controller) => Card(
                  child: Column(
                    children: [
                      YoutubePlayer(
                        controller: controller,
                        showVideoProgressIndicator: true,
                      ),
                      ValueListenableBuilder(
                        valueListenable: controller,
                        builder: (context, value, child) {
                          return Text(
                            controller.metadata.title.isEmpty
                                ? 'Loading...'
                                : controller.metadata.title,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
