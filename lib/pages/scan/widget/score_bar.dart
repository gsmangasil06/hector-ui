import 'package:flutter/material.dart';

class ScoreBar extends StatelessWidget {
  final int score;

  const ScoreBar({
    super.key,
    required this.score
  });

  Color _getColor() {
    if(score >= 80) return Colors.red;
    if(score >= 50) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Risk Score: $score/100",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          )
        ),

        const SizedBox(height: 8,),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 10,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation(_getColor()),
          ),
        )

      ],
    );
  }
}
