import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/config/backend_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackendConfig.initialize();
  runApp(const ExamApp());
}
