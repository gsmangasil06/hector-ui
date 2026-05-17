import 'package:flutter/material.dart';
import 'package:hector/pages/analyze_text/analyze_text_viewmodel.dart';
import 'package:hector/pages/scan/widget/result_card.dart';
import 'package:provider/provider.dart';

class AnalyzeTextScreen extends StatefulWidget {
  final String text;

  const AnalyzeTextScreen({super.key, required this.text});

  @override
  State<AnalyzeTextScreen> createState() => _AnalyzeTextScreenState();
}

class _AnalyzeTextScreenState extends State<AnalyzeTextScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyzeTextViewmodel>().scan(widget.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AnalyzeTextViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Text Analysis"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.text),
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
                              const Text(
                                "Analyzing your message...",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
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
