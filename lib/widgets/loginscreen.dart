import 'package:ats_recruitment_system/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../firebase_auth_imple/fb_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {

  final firebaseAuthService auth = firebaseAuthService();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  void dispose() {
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
            height: screenHeight /6,
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
              'Đăng nhập',
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
                fieldTitle('Email',),
                customField('Nhập email của bạn', emailcontroller, false),
                fieldTitle('Mật khẩu'),
                customField('Nhập mật khẩu của bạn', passcontroller, true),

                GestureDetector(
                  onTap: signIn,
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
                        'Đăng nhập',
                        style: TextStyle(
                          fontFamily: 'NexaBold',
                          fontSize: screenWidth/26,
                          color: Colors.white,
                          letterSpacing: 1
                        ),
                      ),
                    ),
                  ),
                ),




              ],

            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Không có tài khoản? '),
              GestureDetector(
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold
                  ),
                ),
                onTap: (){
                  if (!context.mounted) return;
                  Navigator.pushNamed(context, "/signUp");
                },

              )
            ],
          )


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
          )
        ],
      ),
    );
  }
  void signIn() async{
    String email = emailcontroller.text.trim();
    String password = passcontroller.text.trim();

    User? user = await auth.signInWithEmailAndPassword(email, password);

    if(user != null){
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập thành công')
        ));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(),));
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi không xác định')
      ));
    }
  }
}


