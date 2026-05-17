import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hector/api/core_client.dart';
import 'package:hector/pages/analyze_image/analyze_image_viewmodel.dart';
import 'package:hector/pages/analyze_text/analyze_text_viewmodel.dart';
import 'package:hector/pages/scan/scan_screen.dart';
import 'package:hector/repository/scan_repository.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final Dio dio = Dio(BaseOptions(baseUrl: "https://hector-9yqa.onrender.com"));

  final CoreClient coreClient = CoreClient(dio: dio);
  final ScanRepository scanRepository = ScanRepository(client: coreClient);

  runApp(MyApp(scanRepository: scanRepository));
}

class MyApp extends StatelessWidget {
  final ScanRepository scanRepository;

  const MyApp({super.key, required this.scanRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AnalyzeImageViewmodel(scanRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AnalyzeTextViewmodel(scanRepository: scanRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Hector",
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Colors.black,
            secondary: Colors.redAccent,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
        ),

        home: const ScanScreen(),
      ),
    );
  }
}
