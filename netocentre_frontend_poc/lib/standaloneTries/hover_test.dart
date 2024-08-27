
import 'package:flutter/material.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(HoverTestApp());
}

class HoverTestApp extends StatelessWidget {
  HoverTestApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netocentre Frontend POC',
      debugShowCheckedModeBanner: false,
      home: HoverTest(),
    );
  }
}

class HoverTest extends StatelessWidget{

  HoverTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: (){
            print("on tape");
          },
          onTapDown: (a){
            print("on tap down là");
          },
          child: TextButton(onPressed: (){
            print("pressé");
            }, child: Text("Button"), onHover: (hh){
            if(hh){
              print("hovered");
            }
            else{
              print("not hovered");
            }
          },
          onLongPress: (){
            print("la pression est lloooooooooooongue");
          },
          ),
        ),
      ),
    );
  }
}