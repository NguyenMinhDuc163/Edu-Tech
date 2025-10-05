import 'package:ed_tech/init.dart';

class QuizTakingScreen extends StatefulWidget {
  const QuizTakingScreen({super.key});
  static const String routeName = '/quiz-taking';
  @override
  State<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen> {
  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      screen: Column(
        children: [

        ],
      ),
    );
  }
}
