import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final num rating;
  const RatingBar({
    Key? key,
    this.rating = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _rating(rating);
  }

  Widget _rating(num star) {
    switch (star) {
      case 5:
        return Row(children: const [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
        ]);
      case 4:
        return Row(children: const [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
        ]);
      case 3:
        return Row(children: const [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
        ]);
      case 2:
        return Row(children: const [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
        ]);
      case 1:
        return Row(children: const [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
        ]);
      default:
        return Row(children: const [
          Icon(Icons.star_border, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
          Icon(Icons.star_border, color: Colors.orange),
        ]);
    }
  }
}
