import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePicture extends StatelessWidget {
  final String url;
  final double radius;

  ProfilePicture(this.url, {this.radius = 50.0});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: this.radius * 2,
        height: this.radius * 2,
        imageUrl: this.url,
        placeholder: (context, url) => Shimmer.fromColors(
            child: CircleAvatar(radius: this.radius),
            baseColor: Colors.grey,
            highlightColor: Colors.grey[300]),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
