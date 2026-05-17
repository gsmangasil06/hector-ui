import 'package:flutter/widgets.dart';
import 'package:hector/entity/scan_result.dart';
import 'package:hector/repository/scan_repository.dart';

class AnalyzeTextViewmodel extends ChangeNotifier {
  final ScanRepository _scanRepository;

  AnalyzeTextViewmodel({required ScanRepository scanRepository})
    : _scanRepository = scanRepository;

  ScanResult? _result;

  ScanResult? get result => _result;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  bool get hasData => _result != null;

  Future<void> scan(String text) async {
    _setLoading(true);
    _error = null;

    try {
      _result = await _scanRepository.scan(text);
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
