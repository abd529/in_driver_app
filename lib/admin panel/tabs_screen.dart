import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab Example'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Tab1Widget(),
          Tab2Widget(),
          Tab3Widget(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.search)),
          Tab(icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}

class Tab1Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tab 1',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class Tab2Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tab 2',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class Tab3Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tab 3',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}