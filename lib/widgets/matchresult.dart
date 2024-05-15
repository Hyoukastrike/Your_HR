import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_sticky_widgets/flutter_sticky_widgets.dart';

class matchResult extends StatefulWidget {
  const matchResult({super.key});

  @override
  State<matchResult> createState() => _matchResultState();
}

class _matchResultState extends State<matchResult> {

  double screenHeight = 0;
  double screenWidth = 0;
  int percentComplete = 10;
  int numberIssuePC = 4;
  int numberIssueSk = 200;
  int numberIssueRT = 2;
  int numberIssue = 0;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    numberIssue = calculateNumberIssue();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StickyContainer(
              stickyChildren: const [],
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                height: screenHeight/4,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.blue.shade800),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 55.0,
                          lineWidth: 12.0,
                          backgroundColor: Colors.grey,
                          percent: 0.1,
                          progressColor: Colors.yellow,
                          circularStrokeCap: CircularStrokeCap.round,
                          animation: true,
                          center: Text(
                            "$percentComplete%",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          "$numberIssue issues found",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
                Container(
                    height: screenHeight*3/4,
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Personal Contact",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                "$numberIssuePC issues to fix",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue
                                ),
                              ),
                            )
                          ],
                        ),
                        LinearPercentIndicator(
                          lineHeight: 20,
                          percent: 0.8,
                          progressColor: Colors.indigo,
                          animation: true,
                          animationDuration: 1000,
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Skills",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                "$numberIssueSk issues to fix",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue
                                ),
                              ),
                            )
                          ],
                        ),
                        LinearPercentIndicator(
                          lineHeight: 20,
                          percent: 0.2,
                          progressColor: Colors.redAccent,
                          animation: true,
                          animationDuration: 1000,
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Recruitment Tips",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                "$numberIssueRT issues to fix",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue
                                ),
                              ),
                            )
                          ],
                        ),
                        LinearPercentIndicator(
                          lineHeight: 20,
                          percent: 0.9,
                          progressColor: Colors.indigo,
                          animation: true,
                          animationDuration: 1000,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20, left: 10),
                          child: Text(
                            "Liên hệ cá nhân",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: const Text(
                            "Thông tin cá nhân",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ],
                    )
                ),
          ],
        ),
    );
  }

  int calculateNumberIssue() {
    numberIssue = numberIssuePC + numberIssueSk + numberIssueRT;
    return numberIssue;
  }
}
