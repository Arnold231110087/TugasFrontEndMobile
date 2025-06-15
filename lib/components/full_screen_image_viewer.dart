import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late TransformationController _transformationController;
  int currentIndex = 0;
  double _sliderScale = 1.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _transformationController = TransformationController();
    currentIndex = widget.initialIndex;
  }

  void _updateZoom(double scale) {
    setState(() {
      _sliderScale = scale;
      _transformationController.value = Matrix4.identity()..scale(scale);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
                _sliderScale = 1.0;
                _transformationController.value = Matrix4.identity();
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0,
                  maxScale: 5.0,
                  panEnabled: true,
                  scaleEnabled: true,
                  child: Image.asset(
                    widget.images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          // Close button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Image index text
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              '${currentIndex + 1}/${widget.images.length}',
              style: const TextStyle(color: Colors.white),
            ),
          ),

          // Zoom slider
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Slider(
                  value: _sliderScale,
                  min: 1.0,
                  max: 5.0,
                  divisions: 40,
                  label: _sliderScale.toStringAsFixed(1),
                  onChanged: _updateZoom,
                ),
                Text(
                  'Zoom: ${_sliderScale.toStringAsFixed(1)}x',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
