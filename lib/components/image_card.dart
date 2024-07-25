import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String url;

  const ImageCard({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 300,
        width: 200,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return const Center(
              child: Icon(Icons.error, color: Colors.red, size: 50),
            );
          },
        ),
      ),
    );
  }
}