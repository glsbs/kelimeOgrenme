import 'package:flutter/material.dart';
import 'package:kelime_app/constants/colors.dart';
import 'package:kelime_app/pages/services/quiz_service.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizService _quizServices = QuizService();
  //örnek için şıklar
  List<Map<String, dynamic>> quizList = [];
  int currentQuestionIndex = 0;
  int selectedOption = -1;
  bool isLoading = true;

  void initState() {
    super.initState();
    loadQuiz();
  }

  void loadQuiz() async {
    final data = await _quizServices.getQuizWords();
    setState(() {
      quizList = data;
      isLoading = false;
    });
  }

  void selectOption(int index) {
    setState(() {
      selectedOption = index;
    });
  }

  void nextQuestion() async {
    final currentQuestion = quizList[currentQuestionIndex];
    final options = currentQuestion["options"] as List<dynamic>;
    final String correctWord = currentQuestion["turkWord"];
    final String selectedAnswer = options[selectedOption];
    final String wordId = currentQuestion["wordId"];

    final bool isCorrect = selectedAnswer == correctWord;

    await _quizServices.updateUserWordData(wordId, isCorrect);
    setState(() {
      selectedOption = -1;
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("QUIZ")),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (currentQuestionIndex >= quizList.length) {
      return Scaffold(
        appBar: AppBar(title: Text("QUİZ")),
        body: Center(child: Text("Quiz tamamlandı")),
      );
    }

    final currentQuestion = quizList[currentQuestionIndex];
    final options = currentQuestion["options"] as List<dynamic>;
    final imageWidget =
        currentQuestion["imageUrl"] != null
            ? Image.network(
              currentQuestion["imageUrl"],
              width: double.infinity,

              fit: BoxFit.cover,
            )
            : SizedBox(height: 200);

    final sample =
        currentQuestion["samples"].isNotEmpty ? currentQuestion["samples"] : "";

    return Scaffold(
      backgroundColor: AppColors.body,
      appBar: AppBar(
        title: Text("QUIZ", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.quizAppBar,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Column(
              children: [
                imageWidget,

                SizedBox(height: 20),

                //Samples
                Text(
                  "\"$sample\"",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.quizContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: 350,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${currentQuestion["ingWord"]} ?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),

                      ...List.generate(options.length, (index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: GestureDetector(
                            onTap: () => selectOption(index),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    selectedOption == index
                                        ? Color(0xffD9D9D9)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Text(
                                options[index],
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: selectedOption != -1 ? nextQuestion : null,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff86948F),
                    minimumSize: Size(120, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Sonraki Soru",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
