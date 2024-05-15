import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../class/WorkExperience.dart';

class InputJobTitle extends StatefulWidget {
  @override
  _InputJobTitleState createState() => _InputJobTitleState();
}

class _InputJobTitleState extends State<InputJobTitle> {
  double screenHeight = 0;
  double screenWidth = 0;
  String _skillsInput = '';
  String receivedText = '';
  final _formKey = GlobalKey<FormState>();
  late String nameJobRegex;
  List<WorkExperience> skill = [];

  void _updateSkills() {
    setState(() {
      nameJobRegex = r'$_skillsInput';
    });
  }

  @override
  void initState() {
    super.initState();
    loadTextFromSharedPreferences();
  }

  Future<void> loadTextFromSharedPreferences() async {
    final prefsText = await SharedPreferences.getInstance();
    String text = prefsText.getString('text') ?? '';
    skill = extractWorkExperience(text);
    setState(() {
      receivedText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Change Skills'),
        ),
        body: Container(
          height: screenHeight,
          child: Column(
            children: [
              // ListView.builder(
              //     itemCount: skill.length,
              //     itemBuilder: (context, index) {
              //       WorkExperience workExperience = skill[index];
              //       return ListTile(
              //         title: Text(workExperience.position),
              //         subtitle: Text(workExperience.company),
              //       );
              //     }
              // ),
              Text(receivedText)
            ],
          ),
        )
          ),
    );
  }

  Future<void> uploadResume(String filePath, String url,
      String nameJobRegex) async {
    // Create a new HTTP client
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('resume', 'path/to/your/resume.pdf'));
    var response = await request.send();

    if (response.statusCode == 200) {
      // Parse the response body
      var data = jsonDecode(await response.stream.bytesToString());

      // Access the parsed data
      print(data['name']);
      print(data['email']);
      print(data['phone']);
      print(data['skills']);
      print(data['experience']);
      print(data['education']);
    } else {
      // Handle the error
      print('Error parsing resume: ${response.statusCode}');
    }

    // final hasName = _containsName(name);
    // final hasJobName = _containsJobName(skills);

    // Calculate the percentage complete.
    int percentcomplete = 0;
    // if (hasName != "") {
    //   percentcomplete += 10;
    // }
    // if (hasJobName != "") {
    //   percentcomplete += 10;
    // }

    // Print the results.
    print("Độ hoàn thiện: " + percentcomplete.toString() + "%");
  }


  bool _containsName(String text) {
    // Define a regular expression for the expected name format
    final nameRegex = r'name';
    final nameRegExp = RegExp(nameRegex);

    // Check if the name matches the regex
    return nameRegExp.hasMatch(text);
  }

  bool _containsEmail(String text) {
    // Define a regular expression for the expected email format
    final emailRegex = r'email';
    final emailRegExp = RegExp(emailRegex);

    // Check if the email matches the regex
    return emailRegExp.hasMatch(text);
  }

  bool _containsPhone(String text) {
    // Define a regular expression for the expected phone format
    final phoneRegex = r'phone';
    final phoneRegExp = RegExp(phoneRegex);

    // Check if the phone number matches the regex
    return phoneRegExp.hasMatch(text);
  }

  bool _containsJobName(List<String> skills) {
    // Check if any of the skills match the job name regex.
    final jobNameRegExp = RegExp(nameJobRegex);
    return skills.any((skill) => jobNameRegExp.hasMatch(skill));
  }

  Future<Map<String, dynamic>> parseResumeWithPyResParser(
      String filePath) async {
    // // Create a temporary directory to store the resume file.
    // final tempDir = await Directory.systemTemp.createTemp('resume_parser');
    // final tempFilePath = '${tempDir.path}/resume.pdf';
    //
    // // Copy the resume file to the temporary directory.
    // await File(filePath).copy(tempFilePath);

    // Run the Python script.
    final result = await Process.run(
        'python', ['parse_resume.py', filePath]);

    // Check for errors.
    if (result.exitCode != 0) {
      throw Exception('Error running Python script: ${result.stderr}');
    }

    // Parse the JSON output.
    final parsedResume = jsonDecode(result.stdout) as Map<String, dynamic>;

    // // Delete the temporary directory.
    // await tempDir.delete(recursive: true);

    return parsedResume;
  }

  List<WorkExperience> extractWorkExperience(String text) {
    List<WorkExperience> workExperiences = [];

    List<String> lines = text.split('\n');
    WorkExperience currentWork = WorkExperience('','','',[]);
    bool isTasks = false;

    for (String line in lines) {
      print("Đây là đài tiếng nói Việt Nam: $line");
      if (line.trim().isNotEmpty) {
        if (isTasks) {
          if (line.trim().startsWith('-')) {
            currentWork.tasks.add(line.trim().substring(2));
          } else {
            isTasks = false;
            workExperiences.add(currentWork);
            currentWork = WorkExperience('','','',[]);
          }
        }

        if (line.contains('- đến nay') || line.contains('- nay')) {
          print("CÓ");
          currentWork.period = line.trim();
        } else if (line.contains('- ')) {
          String prefix = line.substring(0, line.indexOf('- ')).trim();
          String content = line.substring(line.indexOf('- ') + 2).trim();

          switch (prefix) {
            case 'Vị trí:':
              currentWork.position = content;
              break;
            case 'Công ty:':
              currentWork.company = content;
              break;
            case 'Nhiệm vụ:':
              currentWork.tasks = [];
              isTasks = true;
              break;
          }
        }
      }
    }

    if (currentWork.period != null || currentWork.position != null || currentWork.company != null) {
      workExperiences.add(currentWork);
    }

    return workExperiences;
  }

}
