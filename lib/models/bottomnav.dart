// import 'package:flutter/material.dart';
// import 'package:gmr/screens/forum.dart';
// import 'package:gmr/screens/home.dart';
// import 'package:gmr/screens/profile.dart';

// class Bottomnav extends StatefulWidget {
//   const Bottomnav({super.key});

//   @override
//   State<Bottomnav> createState() => _BottomnavState();
// }

// class _BottomnavState extends State<Bottomnav> {
//   var selectedindex = 0;
//   PageController pageController = PageController();

//   void OnItemTapped(var index){
//     setState(() {
//       selectedindex = index;
//     });
//     pageController.jumpToPage(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: Theme.of(context).primaryColor,
//       //   title: Text("Bottom Navigation"),
//       // ),
//       // body: Center(child: widgets.elementAt(selectedindex)),
//       body: Center(
//         child: PageView(
//           controller: pageController,
//           children: [
//             HomePage(),
//             CommunityForum(),
//             ProfileScreen(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(items: const<BottomNavigationBarItem>[
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//         BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Forum"),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//       ],
//       currentIndex: selectedindex,
//       selectedItemColor: Colors.blueAccent,
//       unselectedItemColor: Colors.grey,
//       onTap: OnItemTapped,),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:gmr/screens/forum.dart';
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

  void OnItemTapped(var index) {
    setState(() {
      selectedindex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              selectedindex = index;
            });
          },
          children: [
            HomePage(),
            CommunityForum(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: "Forum",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
            currentIndex: selectedindex,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: OnItemTapped,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
          ),
        ),
      ),
    );
  }
}
