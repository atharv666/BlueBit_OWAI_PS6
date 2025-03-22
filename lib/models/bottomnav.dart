import 'package:flutter/material.dart';
import 'package:gmr/screens/home.dart';
import 'package:gmr/screens/profile.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  var selectedindex = 0;
  PageController pageController = PageController();

  void OnItemTapped(var index){
    setState(() {
      selectedindex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   title: Text("Bottom Navigation"),
      // ),
      // body: Center(child: widgets.elementAt(selectedindex)),
      body: Center(
        child: PageView(
          controller: pageController,
          children: [
            HomePage(),
            ProfileScreen()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const<BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      currentIndex: selectedindex,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: OnItemTapped,),
    );
  }
}