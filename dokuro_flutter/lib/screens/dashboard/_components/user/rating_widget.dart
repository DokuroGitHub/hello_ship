import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({Key? key, this.rating = 0, this.length = 0, this.onTap})
      : super(key: key);
  final num rating;
  final num length;
  final VoidCallback? onTap;

  Widget _rating({num rating = 0, num length = 0}) {
    return InkWell(
        onTap: onTap,
        child: Tooltip(
            message: '$length lượt đánh giá',
            child: Row(children: [
              Text(rating.toString(),
                  style: const TextStyle(color: Colors.amber)),
              const Icon(Icons.star, color: Colors.amber)
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return _rating();
  }
}
