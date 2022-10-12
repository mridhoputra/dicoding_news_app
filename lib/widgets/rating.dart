import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final double rating;
  final double maximumRating = 5;

  const Rating({Key? key, required this.rating}) : super(key: key);

  Widget _buildStar(int index) {
    if (index >= rating) {
      return const Icon(
        Icons.star_outline_rounded,
        color: Colors.amber,
      );
    } else if (index > rating - 0.5 && index < rating) {
      return const Icon(
        Icons.star_outline_rounded,
        color: Colors.amber,
      );
    } else if (index > rating - 1 && index < rating) {
      return const Icon(
        Icons.star_half_rounded,
        color: Colors.amber,
      );
    } else {
      return const Icon(
        Icons.star_rounded,
        color: Colors.amber,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...List.generate(maximumRating.toInt(), (index) => _buildStar(index)),
        const SizedBox(width: 2),
        Text(
          rating.toString(),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.black,
              ),
        )
      ],
    );
  }
}
