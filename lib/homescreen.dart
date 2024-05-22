import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'calendarscreen.dart';
import 'loginscreen.dart';
import 'todayscreen.dart';
import 'profilescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  int currentIndex = 1;

  bool isDarkMode = false;

  ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue, // Example color
  );

  ThemeData darkTheme = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xff0a0e21),
    ),
  );

  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarAlt,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
  ];

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Theme(
      data: isDarkMode ? darkTheme : lightTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Attendance',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        drawer: Drawer(
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/background.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          'Menu',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text(
                          'Calendar',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            currentIndex = 0;
                            Navigator.pop(context);
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.today),
                        title: Text(
                          'Today',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            currentIndex = 1;
                            Navigator.pop(context);
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text(
                          'Profile',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            currentIndex = 2;
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.brightness_6),
                  title: Text('Switch Theme'),
                  onTap: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                      print("THEME CHANGED");
                    });
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: IndexedStack(
          index: currentIndex,
          children: [
            CalendarScreen(isDarkMode: isDarkMode,),
            TodayScreen(isDarkMode: isDarkMode,),
            ProfileScreen(isDarkMode: isDarkMode,),
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 2),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = i;
                        });
                      },
                      child: Container(
                        height: screenHeight,
                        width: screenWidth,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                navigationIcons[i],
                                color: i == currentIndex
                                    ? Theme.of(context).primaryColor
                                    : Colors.black54,
                                size: i == currentIndex ? 30 : 26,
                              ),
                              i == currentIndex
                                  ? Container(
                                margin: const EdgeInsets.only(
                                  top: 6,
                                ),
                                height: 3,
                                width: 22,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                  color:
                                  Theme.of(context).primaryColor,
                                ),
                              )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                }
              ],
            ),
          ),
        ),
      ),
    );
  }
}
