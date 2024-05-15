import 'package:ats_recruitment_system/Base_Inc.dart';
import 'package:ats_recruitment_system/widgets/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ats_recruitment_system/Talent_Pools.dart';
import 'package:ats_recruitment_system/Report.dart';

class NavBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Hyoukastrike'),
            accountEmail: Text('hyoukastrike@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                    'https://i.pinimg.com/236x/1c/af/b0/1cafb0b83249dcfeca9c9b21d1aaaa88.jpg',
                  width: 90, height: 90, fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1_fYZCbsmJTFv68e3q3_dcseYcwqHjkyf5wct72LX1w&s'
                ),
                fit: BoxFit.cover
              )
            ),
          ),
          ListTile(
            leading: Icon(Icons.add_business),
            title: Text('Base Inc'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Base_Inc(),
            )),
          ),
          ListTile(
            leading: Icon(Icons.add_circle),
            title: Text('Talent Pools'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Talent_Pools(),
            )),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Tùy chỉnh'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('Báo cáo tuyển dụng'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Report(),
            )),
          ),
          ListTile(
            leading: Icon(Icons.ad_units),
            title: Text('Ứng dụng khác'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.ad_units),
            title: Text('Đăng xuất'),
            onTap: (){
              FirebaseAuth.instance.signOut();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
            }
          ),
        ],
      ),
    );
  }
  
}