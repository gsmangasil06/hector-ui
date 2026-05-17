import 'package:hector/api/core_client.dart';
import 'package:hector/entity/scan_result.dart';

class ScanRepository {
  final CoreClient client;

  ScanRepository({
    required this.client
  });

  Future<ScanResult> scan(String text) async {
    return await client.scanText(text);
  }

  Future<ScanResult> scanBase64Image(String base64Image) async {
    return await client.scanBase64Image(base64Image);
  }

}