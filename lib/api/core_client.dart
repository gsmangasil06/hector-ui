import 'package:dio/dio.dart';
import 'package:hector/entity/scan_result.dart';
import 'package:hector/model/scan_result.dart';

class CoreClient {
  final Dio dio;

  CoreClient({
    required this.dio
  });

  Future<ScanResult> scanText(String text) async {
    final response = await dio.post(
      "/text-scams/detect",
      data: { "text": text },
    );

    final scanResult = ScanResultModel.fromJSON(response.data);

    return ScanResult(
      classification: scanResult.classification,
      reasons: scanResult.reasons,
      riskLabel: scanResult.riskLabel,
      scamType: scanResult.scamType,
      score: scanResult.score
    );

  }

  Future<ScanResult> scanBase64Image(String base64Image) async {
    final response = await dio.post(
      "/image-scams/detect",
      data: { "base64Image": base64Image },
    );

    final scanResult = ScanResultModel.fromJSON(response.data);

    return ScanResult(
        classification: scanResult.classification,
        reasons: scanResult.reasons,
        riskLabel: scanResult.riskLabel,
        scamType: scanResult.scamType,
        score: scanResult.score
    );

  }

}