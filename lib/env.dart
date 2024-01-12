import 'package:flutter_dotenv/flutter_dotenv.dart';

loadDotenv() async {
  await dotenv.load(fileName: '.env');
}