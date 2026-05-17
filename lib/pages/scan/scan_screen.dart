import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hector/pages/analyze_image/analyze_image_screen.dart';
import 'package:hector/pages/analyze_text/analyze_text_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _controller = TextEditingController();
  Uint8List? _imageBytes; // for web
  String? _imageMimeType;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  VoidCallback _pickImage(ImageSource source) {
    return () async {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageMimeType = lookupMimeType(pickedFile.path) ?? "image/jpeg";
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMessageInput(),

                const SizedBox(height: 12),

                if (_imageBytes == null)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("OR")],
                  ),

                const SizedBox(height: 12),

                _buildImageInput(),

                const SizedBox(height: 16),

                _buildAnalyzeButton(context),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageInput() {
    if (_imageBytes == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _pickImage(ImageSource.gallery),
            label: const Text("Choose from gallery"),
            icon: const Icon(Icons.photo_library),
          ),
          ElevatedButton.icon(
            onPressed: _pickImage(ImageSource.camera),
            label: const Text("Take a photo"),
            icon: const Icon(Icons.camera),
          ),
        ],
      );
    }

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.memory(_imageBytes!, fit: BoxFit.fitWidth),
          ),
        ),
        Positioned(
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () {
              _clearImage();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return TextField(
      controller: _controller,
      maxLines: 6,
      onChanged: (value) {
        if (value.isNotEmpty && _imageBytes != null) {
          _clearImage();
        }
      },
      decoration: InputDecoration(
        hintText: "Paste suspicious message...",
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildAnalyzeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: _detectScam(context),
        icon: const Icon(Icons.shield_outlined),

        label: Text(
          "Ask Hector to Analyze",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }

  VoidCallback? _detectScam(BuildContext ctx) {
    return () {
      final text = _controller.text;
      final imageBytes = _imageBytes;
      final imageMimeType = _imageMimeType;

      if (_imageBytes == null) {
        _controller.clear();
      } else {
        _clearImage();
      }

      MaterialPageRoute route = MaterialPageRoute(
        builder: (_) {
          if (imageBytes == null) {
            return AnalyzeTextScreen(text: text);
          }

          return AnalyzeImageScreen(
            imageBytes: imageBytes,
            imageMimeType: imageMimeType!,
          );
        },
      );

      Navigator.push(ctx, route);
    };
  }

  void _clearImage() {
    setState(() {
      _imageBytes = null;
      _imageMimeType = null;
    });
  }
}
