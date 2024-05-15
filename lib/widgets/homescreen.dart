import 'package:ats_recruitment_system/NavBar.dart';
import 'package:ats_recruitment_system/widgets/matchresult.dart';
import 'package:ats_recruitment_system/trackingcv.dart';
import 'package:ats_recruitment_system/widgets/worknote.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Catalogue {
  final String urlImage;
  final String title;

  const Catalogue({required this.urlImage, required this.title});

}

class _HomeScreenState extends State<HomeScreen> {


  late Stream<QuerySnapshot> imageStream;
  int currentSlideIndex = 0;
  CarouselController carouselController = CarouselController();

  @override
  void initState(){
    super.initState();
    imageStream = FirebaseFirestore.instance.collection('banner').snapshots();
  }

  double screenHeight = 0;
  double screenWidth = 0;

  List<Catalogue> item = [
    Catalogue(
      urlImage:
        'https://firebasestorage.googleapis.com/v0/b/ats-system-1c0ae.appspot.com/o/introduction%20(1).png?alt=media&token=74cf2ea5-b783-469c-92a2-ce8f291c3a66',
      title: 'Giới thiệu công ty',
    ),Catalogue(
      urlImage:
        'https://firebasestorage.googleapis.com/v0/b/ats-system-1c0ae.appspot.com/o/hr.png?alt=media&token=0a7322b2-4f9d-4696-82e0-cc0d3d919c59',
      title: 'Quản trị nhân sự',
    ),Catalogue(
      urlImage:
        'https://firebasestorage.googleapis.com/v0/b/ats-system-1c0ae.appspot.com/o/task.png?alt=media&token=bc62a09b-858d-422c-a903-4d3873dcb8e9',
      title: 'Quản lý công việc',
    ),Catalogue(
      urlImage:
        'https://firebasestorage.googleapis.com/v0/b/ats-system-1c0ae.appspot.com/o/task%20(1).png?alt=media&token=e253a81a-798f-4c3b-b923-9e89904349bc',
      title: 'Ghi chú công việc',
    ),Catalogue(
      urlImage:
        'https://firebasestorage.googleapis.com/v0/b/ats-system-1c0ae.appspot.com/o/star.png?alt=media&token=b704e8d6-cd39-42ac-8692-6b144a1466f7',
      title: 'Ứng viên tiềm năng',
    ),Catalogue(
      urlImage:
        'https://firebasestorage.googleapis.com/v0/b/ats-system-1c0ae.appspot.com/o/cv.png?alt=media&token=2d5e20cb-5297-4dd4-a3a7-a4279f1c861f',
      title: 'Tracking CV',
    ),
  ];

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/images/bg/bg.png",
          height: screenHeight,
          width: screenWidth,
          fit: BoxFit.cover,
    ),
      Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Trang chủ'),
        centerTitle: true,
      ),
      drawer: NavBar(),
      body: Container(
        height: screenHeight,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/bg/bg.png"),
        //     fit: BoxFit.cover
        //   )
        // ),
        constraints: BoxConstraints.expand(),


        child: Column(
          children:<Widget> [
            Container(
              height: screenHeight/10,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) => catalogue(item: item[index], index: index),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 2,),
                ),
              ),
            SizedBox(height: screenHeight/30,),

            StreamBuilder<QuerySnapshot>(
                stream: imageStream,
                builder: (_,snapshot){
                  if(snapshot.hasData && snapshot.data!.docs.length>1){
                    return CarouselSlider.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (_, index, __){
                        DocumentSnapshot sliderImage = snapshot.data!.docs[index];
                        return Image.network(sliderImage['imageURL'],
                        fit: BoxFit.cover
                        );
                      },
                      options: CarouselOptions(
                        height: screenHeight/4,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        onPageChanged: (index,_){
                          currentSlideIndex = index;
                        }
                      ),
                    );
                  }else{
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

            SizedBox(height: screenHeight/10,),

          ],
        ),

      ),
    ),
    ],
    );


  }

  Widget catalogue({required Catalogue item, required int index})
  => GestureDetector(
    onTap: (){
      switch(index){
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
        case 3:
          Navigator.push(context, MaterialPageRoute(builder: (context) => WorkNote()));
          break;
        case 4:
          Navigator.push(context, MaterialPageRoute(builder: (context) => matchResult()));
          break;
        case 5:
          Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingCV()));
          break;
        default:
          break;
      }

    },
    child: Container(
        alignment: Alignment.center,
        width: screenWidth/5,
        padding: EdgeInsets.symmetric(horizontal: screenWidth/40),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 175, 200, 200),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 3.0
          )]
        ),

        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),),
            Expanded(
              child: Image.network(
                item.urlImage,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 2,),
            Text(
              item.title,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
    ),
  );
}
