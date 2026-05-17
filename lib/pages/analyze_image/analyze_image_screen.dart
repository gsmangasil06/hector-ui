import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hector/pages/analyze_image/analyze_image_viewmodel.dart';
import 'package:hector/pages/scan/widget/result_card.dart';
import 'package:provider/provider.dart';

class AnalyzeImageScreen extends StatefulWidget {
  final Uint8List imageBytes;
  final String imageMimeType;

  const AnalyzeImageScreen({
    super.key,
    required this.imageBytes,
    required this.imageMimeType,
  });

  @override
  State<AnalyzeImageScreen> createState() => _AnalyzeImageScreenState();
}

class _AnalyzeImageScreenState extends State<AnalyzeImageScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyzeImageViewmodel>().scan(
        widget.imageBytes,
        widget.imageMimeType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AnalyzeImageViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Analysis"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.memory(widget.imageBytes, fit: BoxFit.contain),
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, 0.08),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                ),
                              ),
                          child: child,
                        ),
                      );
                    },
                    child: vm.isLoading
                        ? Column(
                            key: const ValueKey("loading"),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              // Animated text shimmer or fade
                              AnimatedOpacity(
                                duration: const Duration(seconds: 1),
                                opacity: vm.isLoading ? 1.0 : 0.0,
                                child: const Text(
                                  "Analyzing your image...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : vm.result == null
                        ? const SizedBox.shrink()
                        : SingleChildScrollView(
                            key: ValueKey(vm.result),
                            child: ResultCard(result: vm.result!),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
