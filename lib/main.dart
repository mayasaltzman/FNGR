import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_milestone/pages/auth/settings_page.dart';
import '/../services/firebase_service.dart';
import '../services/location_service.dart';
import 'pages/home/home_page.dart'; // we’ll define this next
import 'pages/profile/user_profile_page.dart';
import 'pages/chat/chat_list_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/profile/create_profile_page.dart';
import 'pages/profile/edit_profile_page.dart';
import 'pages/profile/widgets/select_menu_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final LocationService _locationService = LocationService();
  await _locationService.initLocation();
  _locationService.startLocationUpdates();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "Gilroy-bold",
          colorScheme: const ColorScheme.light(
              primary: Color(0xFFFAF5F8), //app background
              primaryContainer:
                  Color(0xFFF9E7F2), //to distinguish from background
              primaryFixed: Color(0xFFAA4E85), //pink dark text
              secondary: Color(0xFFD461A6), //header color
              secondaryFixed: Color(0xFFFFFFFF), //white
              tertiary: Color(0xFFFF9B55),
              tertiaryContainer: Color(0xFFFFF0E6),
              tertiaryFixed: Color(0xFFFFE0CA)),
          textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontSize: 22,
              ),
              bodyMedium: TextStyle(
                fontSize: 16,
              ),
              bodySmall: TextStyle(fontSize: 14))),
      debugShowCheckedModeBanner: false,
      // home: const HomePage(),

      //home: const LoginPage(),

      //home: const LoginPage(),
      //home: const EditProfilePage(userId: "1a4dZXRtA80tkguo1REw"),
      //home: const SelectPage(fieldType: 'Sexuality'),
      home: const CreateProfilePage(),
    );
  }
}

class NavMenu extends StatefulWidget {
  int selectedIndex;

  NavMenu({super.key, this.selectedIndex = 0});

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  //nt _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final FirebaseService _firebaseService = FirebaseService();
    final currentUserId = _firebaseService.currentUserId ?? '';

    _pages = [
      const HomePage(),
      const ChatListPage(listType: "accepted"),
      EditProfilePage(userId: currentUserId),

      //EditProfilePage(userId: currentUserId)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      body: _pages[widget.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.primaryFixed,
        currentIndex: widget.selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
