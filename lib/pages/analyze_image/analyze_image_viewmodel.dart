import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hector/entity/scan_result.dart';
import 'package:hector/repository/scan_repository.dart';

class AnalyzeImageViewmodel extends ChangeNotifier {
  final ScanRepository scanRepository;

  AnalyzeImageViewmodel(this.scanRepository);

  ScanResult? _result;

  ScanResult? get result => _result;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  bool get hasData => _result != null;

  Future<void> scan(Uint8List imageBytes, String imageMimeType) async {
    _setLoading(true);
    _error = null;

    try {
      final base64 = base64Encode(imageBytes);
      final base64Image = "data:$imageMimeType;base64,$base64";

      _result = await scanRepository.scanBase64Image(base64Image);
    } catch (e) {
      _error = e.toString();
      _result = null;
    }

    _setLoading(false);
  }

  void clear() {
    _result = null;
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
