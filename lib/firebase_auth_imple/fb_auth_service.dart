import 'package:firebase_auth/firebase_auth.dart';

class firebaseAuthService{
    FirebaseAuth auth = FirebaseAuth.instance;

    Future<User?> signUpWithEmailAndPassword(String email, String password) async {
        try{
            UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
            return credential.user;
        }catch(e){
            print('Lỗi không xác định');
        }
        return null;
    }

    Future<User?> signInWithEmailAndPassword(String email, String password) async {
        try{
            UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
            return credential.user;
        }catch(e){
            print('Lỗi không xác định');
        }
        return null;
    }

}