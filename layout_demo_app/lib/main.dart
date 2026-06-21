import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Layout Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      home: const LayoutDemoPage(),
    );
  }
}

class LayoutDemoPage extends StatefulWidget {
  const LayoutDemoPage({super.key});

  @override
  State<LayoutDemoPage> createState() => _LayoutDemoPageState();
}

class _LayoutDemoPageState extends State<LayoutDemoPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Row & Column Playground State
  bool _isRow = true;
  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.center;
  CrossAxisAlignment _crossAxisAlignment = CrossAxisAlignment.center;
  MainAxisSize _mainAxisSize = MainAxisSize.max;

  // Container & Padding Playground State
  double _paddingVal = 16.0;
  double _marginVal = 16.0;
  Alignment _alignment = Alignment.center;
  bool _hasDecoration = true;
  double _borderRadius = 12.0;

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
        children: [
          _buildShowcaseTab(),
          _buildPlaygroundTab(),
        ],
      ),
    );
  }

  // --- TAB 1: WORKSHOP SHOWCASE ---
  Widget _buildShowcaseTab() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // ตัวอย่างที่ 1: การใช้ Container และ Center
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.indigo.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade100.withAlpha(120)),
              ),
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade700, Colors.purple.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.shade700.withAlpha(60),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Centered Box',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 20, thickness: 1, indent: 20, endIndent: 20),
          
          // ตัวอย่างที่ 2: การใช้ Row และ Column ร่วมกัน
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade50, Colors.teal.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade100.withAlpha(120)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Column 1
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.shade900.withAlpha(15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.star, size: 28, color: Colors.amber),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Rating',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  // Column 2
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.shade900.withAlpha(15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(Icons.settings, size: 28, color: Colors.blueGrey.shade600),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Settings',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  // Column 3
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.shade900.withAlpha(15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.share, size: 28, color: Colors.redAccent),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Share',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 20, thickness: 1, indent: 20, endIndent: 20),

          // ตัวอย่างที่ 3: การใช้ Padding และ Container เพื่อสร้าง Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Category Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'FEATURED',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Title of the Card',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This is a description text for the card. It demonstrates how padding works inside a container with margin and shadow.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Learn More',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- TAB 2: INTERACTIVE PLAYGROUND ---
  Widget _buildPlaygroundTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row/Column Section
          _buildPlaygroundHeader('1. Row & Column Playground', Icons.grid_view),
          const SizedBox(height: 10),
          _buildRowColumnPreview(),
          const SizedBox(height: 12),
          _buildRowColumnControls(),
          
          const SizedBox(height: 28),
          
          // Container & Padding Section
          _buildPlaygroundHeader('2. Container & Padding Playground', Icons.aspect_ratio),
          const SizedBox(height: 10),
          _buildContainerPreview(),
          const SizedBox(height: 12),
          _buildContainerControls(),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildPlaygroundHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal.shade800, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildRowColumnPreview() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.teal.shade100, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _isRow
              ? Row(
                  mainAxisAlignment: _mainAxisAlignment,
                  crossAxisAlignment: _crossAxisAlignment,
                  mainAxisSize: _mainAxisSize,
                  children: _buildPreviewItems(),
                )
              : Column(
                  mainAxisAlignment: _mainAxisAlignment,
                  crossAxisAlignment: _crossAxisAlignment,
                  mainAxisSize: _mainAxisSize,
                  children: _buildPreviewItems(),
                ),
        ),
      ),
    );
  }

  List<Widget> _buildPreviewItems() {
    return [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.tealAccent.shade700,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text('3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    ];
  }

  Widget _buildRowColumnControls() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Direction Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Direction:', style: TextStyle(fontWeight: FontWeight.bold)),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(value: true, label: Text('Row'), icon: Icon(Icons.arrow_forward)),
                    ButtonSegment<bool>(value: false, label: Text('Column'), icon: Icon(Icons.arrow_downward)),
                  ],
                  selected: {_isRow},
                  onSelectionChanged: (Set<bool> val) {
                    setState(() {
                      _isRow = val.first;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // MainAxisAlignment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('MainAxisAlignment:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<MainAxisAlignment>(
                  value: _mainAxisAlignment,
                  onChanged: (MainAxisAlignment? val) {
                    if (val != null) {
                      setState(() {
                        _mainAxisAlignment = val;
                      });
                    }
                  },
                  items: MainAxisAlignment.values.map((val) {
                    return DropdownMenuItem(value: val, child: Text(val.toString().split('.').last));
                  }).toList(),
                ),
              ],
            ),
            
            // CrossAxisAlignment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('CrossAxisAlignment:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<CrossAxisAlignment>(
                  value: _crossAxisAlignment,
                  onChanged: (CrossAxisAlignment? val) {
                    if (val != null) {
                      setState(() {
                        _crossAxisAlignment = val;
                      });
                    }
                  },
                  items: CrossAxisAlignment.values.map((val) {
                    return DropdownMenuItem(value: val, child: Text(val.toString().split('.').last));
                  }).toList(),
                ),
              ],
            ),
            
            // MainAxisSize
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('MainAxisSize:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<MainAxisSize>(
                  value: _mainAxisSize,
                  onChanged: (MainAxisSize? val) {
                    if (val != null) {
                      setState(() {
                        _mainAxisSize = val;
                      });
                    }
                  },
                  items: MainAxisSize.values.map((val) {
                    return DropdownMenuItem(value: val, child: Text(val.toString().split('.').last));
                  }).toList(),
                ),
              ],
            ),
            
            const Divider(height: 24),
            // Live Code Snippet
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_isRow ? "Row" : "Column"}(\n'
                '  mainAxisAlignment: MainAxisAlignment.${_mainAxisAlignment.toString().split('.').last},\n'
                '  crossAxisAlignment: CrossAxisAlignment.${_crossAxisAlignment.toString().split('.').last},\n'
                '  mainAxisSize: MainAxisSize.${_mainAxisSize.toString().split('.').last},\n'
                '  children: <Widget>[...],\n'
                ')',
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerPreview() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(_marginVal),
          padding: EdgeInsets.all(_paddingVal),
          alignment: _alignment,
          width: 130,
          height: 130,
          decoration: _hasDecoration
              ? BoxDecoration(
                  color: Colors.teal.shade600,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.shade900.withAlpha(40),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                )
              : null,
          color: _hasDecoration ? null : Colors.teal.shade600,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainerControls() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text('Padding: ${_paddingVal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Slider(
                    value: _paddingVal,
                    min: 0,
                    max: 40,
                    onChanged: (val) {
                      setState(() {
                        _paddingVal = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            
            // Margin
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text('Margin: ${_marginVal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Slider(
                    value: _marginVal,
                    min: 0,
                    max: 40,
                    onChanged: (val) {
                      setState(() {
                        _marginVal = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            
            // Alignment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alignment:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<Alignment>(
                  value: _alignment,
                  onChanged: (Alignment? val) {
                    if (val != null) {
                      setState(() {
                        _alignment = val;
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: Alignment.topLeft, child: Text('topLeft')),
                    DropdownMenuItem(value: Alignment.topCenter, child: Text('topCenter')),
                    DropdownMenuItem(value: Alignment.topRight, child: Text('topRight')),
                    DropdownMenuItem(value: Alignment.centerLeft, child: Text('centerLeft')),
                    DropdownMenuItem(value: Alignment.center, child: Text('center')),
                    DropdownMenuItem(value: Alignment.centerRight, child: Text('centerRight')),
                    DropdownMenuItem(value: Alignment.bottomLeft, child: Text('bottomLeft')),
                    DropdownMenuItem(value: Alignment.bottomCenter, child: Text('bottomCenter')),
                    DropdownMenuItem(value: Alignment.bottomRight, child: Text('bottomRight')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // BoxDecoration Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Use BoxDecoration:', style: TextStyle(fontWeight: FontWeight.bold)),
                Switch(
                  value: _hasDecoration,
                  onChanged: (val) {
                    setState(() {
                      _hasDecoration = val;
                    });
                  },
                ),
              ],
            ),
            
            if (_hasDecoration) ...[
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text('BorderRadius: ${_borderRadius.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Slider(
                      value: _borderRadius,
                      min: 0,
                      max: 30,
                      onChanged: (val) {
                        setState(() {
                          _borderRadius = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
            
            const Divider(height: 24),
            // Live Code Snippet
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Container(\n'
                '  margin: const EdgeInsets.all(${_marginVal.toStringAsFixed(0)}),\n'
                '  padding: const EdgeInsets.all(${_paddingVal.toStringAsFixed(0)}),\n'
                '  alignment: Alignment.${_alignment.toString().split('.').last},\n'
                '  ${_hasDecoration ? 'decoration: BoxDecoration(\n'
                    '    color: Colors.teal,\n'
                    '    borderRadius: BorderRadius.circular(${_borderRadius.toStringAsFixed(0)}),\n'
                    '  )' : 'color: Colors.teal,'}\n'
                '  child: ...,\n'
                ')',
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
