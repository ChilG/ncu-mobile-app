import 'package:flutter/material.dart';
import 'package:layout_demo_app/widgets/showcase_tab.dart';
import 'package:layout_demo_app/widgets/playground_tab.dart';

class LayoutDemoPage extends StatefulWidget {
  const LayoutDemoPage({super.key});

  @override
  State<LayoutDemoPage> createState() => _LayoutDemoPageState();
}

class _LayoutDemoPageState extends State<LayoutDemoPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Layout Demo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        elevation: 4,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.teal.shade200,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Workshop Showcase'),
            Tab(icon: Icon(Icons.tune), text: 'Interactive Playground'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ShowcaseTab(),
          PlaygroundTab(),
        ],
      ),
    );
  }
}
