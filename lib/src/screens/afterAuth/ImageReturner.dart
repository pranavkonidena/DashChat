import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageReturner extends StatelessWidget {
  final List<String> imageUrls;
  const ImageReturner({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: CachedNetworkImage(
            imageUrl: imageUrls[index],
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
      },
    );
  }
}
