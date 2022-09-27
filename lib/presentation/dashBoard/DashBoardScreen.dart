import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> with SingleTickerProviderStateMixin{
  int _currentTab = 0;
  List<Widget> _tabList = [];
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: length, vsync: this)
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('dashboard'),),
      body: TabBarView(
        controller: ,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "current request"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "upcoming request"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_pin_outlined), label: "past request"),
        ],
      ),
    );
  }
}
