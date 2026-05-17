import 'package:flutter/material.dart';

class ReasonTile extends StatelessWidget {
  final String text;

  const ReasonTile({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("⚠ "),
          Expanded(child: Text(text))
        ],
      ),
    );
  }
}
