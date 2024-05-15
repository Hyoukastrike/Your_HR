import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ats_recruitment_system/widgets/inputjobtitle.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:email_validator/email_validator.dart';
import 'package:username_validator/username_validator.dart';


class TrackingCV extends StatefulWidget {
  const TrackingCV({super.key});

  @override
  State<TrackingCV> createState() => _TrackingCVState();
}

class _TrackingCVState extends State<TrackingCV> {

  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(height: screenHeight/3,),
          GestureDetector(
            child: Container(
              height: screenHeight/15,
              width: screenWidth/3,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(30)
              ),
              child: const Center(
                child: Text(
                  'Tracking CV',
                  style: TextStyle(
                      fontFamily: 'NexaBold',
                      fontSize: 18,
                      color: Colors.black,
                      letterSpacing: 1
                  ),
                ),
              ),
            ),
            onTap: () async{
              final result = await FilePicker.platform.pickFiles();
              if (result == null || result.files.isEmpty) {
                // No file selected, handle the situation accordingly.
                print('No PDF file selected.');
                return;
              }
              final file = result.files.first;
              print('Name: ${file.name}');
              print('Bytes: ${file.bytes}');
              print('Size: ${file.size}');
              print('Extension: ${file.extension}');
              print('Path: ${file.path}');

              // Get the path of the selected file.
              final filePath = file.path;
              const maxTextLimit = 10000;

              if(await File(filePath!).exists()){
                String accumulatedText = '';
                List<String> textPage = [];
                int fileIndex = 1;
                final directory = await getApplicationDocumentsDirectory();
                final document = PdfDocument(inputBytes: await File(filePath).readAsBytesSync());
                for(int i =0; i<document.pages.count; i++){
                  String text = PdfTextExtractor(document).extractText(startPageIndex: i, endPageIndex: i);
                  accumulatedText += text;
                  if (kDebugMode) {
                    text = text.replaceAll("\r\n", "");
                    accumulatedText = accumulatedText.replaceAll("\r\n", "");
                    String namecandidate = getName(text);
                    PhoneNumber? phoneNumber = getPhoneNumber(text);
                    List<String> emails = getEmail(text);
                    print(textPage.toString());
                    final prefsText = await SharedPreferences.getInstance();
                    await prefsText.setString('text', accumulatedText);
                    // PhoneNumber number = PhoneNumber.parse(phoneNumber.toString(), destinationCountry: IsoCode.VN);
                    // final formattedNsn = number.formatNsn();
                    print(namecandidate);
                    print(phoneNumber);
                    print(emails);
                    print("Page ${i}: $accumulatedText");

                  }
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) => InputJobTitle()));
                // final prefs = await SharedPreferences.getInstance();
                // await prefs.setString('filePath', filePath);
                document.dispose();


              }
            },
          ),
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 60,
              width: screenWidth/3,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  )
                ],
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )
              ),
              child: Center(
                child: Text(
                  'Tracking CVs',
                  style: TextStyle(
                      fontFamily: 'NexaBold',
                      fontSize: 18,
                      color: Colors.black,
                      letterSpacing: 1
                  ),
                ),
              ),
            ),
            onTap: () async{
              final result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom,allowedExtensions: ['pdf']);
              if (result == null) return;
              openFiles(result.files);
            },
          ),
        ],
      ),
    );
  }

  Future<void> openFile(PlatformFile file) async {
    // OpenFile.open(file.path!);

  }

  void openFiles(List<PlatformFile> files) {
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => FilesPage(
    //   files: files,
    //   onOpenedFile: openFile
    // )));
  }

  Iterable<PhoneNumber> findPhoneNumber(String text){
    final found = PhoneNumber.findPotentialPhoneNumbers(text);
    return found;
  }

  PhoneNumber? getPhoneNumber(String text){
    PhoneNumber? number = findPhoneNumber(text).firstOrNull;
    if (number == null){
      print("No matching text");
    }
    print(number);
    return number;
}

  List<String> getEmail(String text){
    List<String> emails = [];
    RegExp emailRegex = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b');
    Iterable<Match> emailMatches = emailRegex.allMatches(text);
    for (Match match in emailMatches) {
      String? email = match.group(0);
      if (EmailValidator.validate(email!)) {
        emails.add(email);
      }
    }
    return emails;
  }

  String getName(String text) {
    RegExp nameRegex = RegExp(r'[a-zA-ZŠšŽžÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÙÚÛÜÝŸÞàáâãäåæçèéêëìíîïñòóôõöøùúûüýÿþƒ]');
    Match? nameMatch = nameRegex.firstMatch(text);
    if (nameMatch != null) {
      String name = nameMatch.group(0)!;
      return name;
    }
    return ""; // Return an empty string if no name is found
  }

}


