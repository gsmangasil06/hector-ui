import 'package:flutter/material.dart';
import 'package:hector/entity/scan_result.dart';
import 'package:hector/pages/scan/widget/reason_tile.dart';
import 'package:hector/pages/scan/widget/risk_badge.dart';
import 'package:hector/pages/scan/widget/score_bar.dart';

class ResultCard extends StatelessWidget {
  final ScanResult result;

  const ResultCard({
    super.key,
    required this.result
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black12
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                result.classification ?? "Unknown",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                )
              ),
              RiskBadge(label: result.riskLabel)
            ],
          ),

          const SizedBox(height: 16,),

          //Score
          ScoreBar(score: result.score ?? 0),

          const SizedBox(height: 20,),

          //Scam Type
          Text(
            "Type: ${result.scamType ?? "N/A"}",
            style: const TextStyle(
              color: Colors.white70
            ),
          ),

          const SizedBox(height: 20,),

          //reasons
          const Text(
            "Why this is flagged:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ...(result.reasons ?? []).map(
              (r) => ReasonTile(text: r),
          )
        ],

      ),
    );
  }
}
