import 'package:ats_recruitment_system/firebase_auth_imple/fb_auth_service.dart';
import 'package:ats_recruitment_system/widgets/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../main.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final firebaseAuthService auth = firebaseAuthService();
  bool isSigningUp = false;

  TextEditingController idcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  void dispose() {
    idcontroller.dispose();
    emailcontroller.dispose();
    passcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          isKeyboardVisible ? SizedBox(height: screenHeight/16,) : Container(
            height: screenHeight /4,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(70),
              ),
            ),
            child: Center(
              child: Icon(Icons.person, color: Colors.white, size: screenWidth/5,),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: screenHeight/15,
                bottom: screenHeight/20),
            child: Text(
              'Đăng ký',
              style: TextStyle(
                  fontSize: screenWidth/18,
                  fontFamily: 'NexaBold'
              ),
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: screenWidth/12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fieldTitle('ID nhân viên'),
                  customField('Nhập ID nhân viên của bạn', idcontroller, false),
                  fieldTitle('Email đăng ký'),
                  customField('Nhập email đăng ký', emailcontroller, false),
                  fieldTitle('Mật khẩu'),
                  customField('Nhập mật khẩu đăng ký', passcontroller, true),
                  GestureDetector(
                    onTap: signUp,
                    child: Container(
                      height: 60,
                      width: screenWidth,
                      margin: EdgeInsets.only(top: screenHeight/40),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Center(
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(
                              fontFamily: 'NexaBold',
                              fontSize: screenWidth/26,
                              color: Colors.white,
                              letterSpacing: 1
                          ),
                        ),
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
  Widget fieldTitle(String title){
    return Text(
      title,
      style: TextStyle(
          fontSize: screenWidth/26,
          fontFamily: 'NexaRegular'
      ),
    );
  }

  Widget customField(String hint, TextEditingController controller, bool obscure){
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenWidth/50),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 2)
            )
          ]
      ),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth/8,
              child: Icon(
                Icons.account_circle_rounded,
                color: Colors.redAccent,
                size: screenWidth/15,
              ),
            ),
            Expanded(
              child: Padding(
              padding: EdgeInsets.only(right: screenWidth/12),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight/35,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
               ),
                maxLines: 1,
                obscureText: obscure,
              ),
             )
             ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Đã có tài khoản? '),
                GestureDetector(
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  onTap: (){
                    if (!mounted) return;
                    Navigator.pushNamed(context, "/login");
                  },

                )
              ],
            )
          ],

       ),

    );

  }
  void signUp() async{

    setState(() {
      isSigningUp = true;
    });

    String email = emailcontroller.text.trim();
    String password = passcontroller.text.trim();

    User? user = await auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if(user != null){
      if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tài khoản đã được tạo thành công')
        ));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(),));

    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi không xác định')
      ));
    }
  }
}

