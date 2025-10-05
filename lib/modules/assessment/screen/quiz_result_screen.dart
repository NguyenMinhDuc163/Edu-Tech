import 'package:ed_tech/init.dart';

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});
  static const String routeName = '/quiz-result';
  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      screen: Column(
        children: [],
      ),
    );
  }
}
