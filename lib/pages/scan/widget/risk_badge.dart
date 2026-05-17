import 'package:flutter/material.dart';

class RiskBadge extends StatelessWidget {
  final String? label;
  const RiskBadge({
    super.key,
    this.label
  });

  Color _getColor() {
    switch (label) {
      case "VERY HIGH":
        return Colors.red;
      case "HIGH":
        return Colors.orange;
      case "MODERATE":
        return Colors.amber;
      case "LOW":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6
      ),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getColor())
      ),
      child: Text(
        label ?? "Unknown",
        style: TextStyle(
          color: _getColor(),
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
