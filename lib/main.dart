import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'theme_provider.dart';
import 'note_provider.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDarkThemePref = prefs.getBool('isDarkTheme');
     bool isDarkTheme = isDarkThemePref ?? false;
   runApp(
    MultiProvider(
         providers: [
          ChangeNotifierProvider(
             create: (context) => NoteProvider(),
           ),
           ChangeNotifierProvider(
             create: (context) => ThemeProvider(isDarkTheme)
          ),
        ],
         child: const MyApp(),
        ),
  );


}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  {
  

 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return  Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return  MaterialApp(
              title: 'MyNotepad',
              theme: themeProvider.getTheme(),
            home:  HomeScreen(),
          ); 
    
         }
       );
    
        
  }
}






















