import 'package:flutter/material.dart';
import 'package:temp/widgets/player.dart';
import 'package:temp/widgets/side_bar.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void refresh() {
    setState(() {});
  }

  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6BFDA),
      body: SafeArea(
        child: isCollapsed
            ? Player(
                width: 1000,
                notifyParent: refresh,
              )
            : FittedBox(
                child: Row(
                  children: [
                    SideBar(
                      notifyParent: refresh,
                    ),
                    Player(
                      width: 700,
                      notifyParent: refresh,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
