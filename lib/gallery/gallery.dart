import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> galleries = ['testUrl1', 'testUrl2'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('gallery'),
      ),
      body: Column(
        children: galleries.map((gallery) => Text(gallery)).toList(),
      ),
    );
  }
}
