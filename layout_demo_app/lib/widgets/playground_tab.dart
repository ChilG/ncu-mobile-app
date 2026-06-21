import 'package:flutter/material.dart';

class PlaygroundTab extends StatefulWidget {
  const PlaygroundTab({super.key});

  @override
  State<PlaygroundTab> createState() => _PlaygroundTabState();
}

class _PlaygroundTabState extends State<PlaygroundTab> {
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
  Widget build(BuildContext context) {
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
