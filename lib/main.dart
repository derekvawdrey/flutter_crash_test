import 'package:flutter/material.dart';
import 'package:flutter_crash_test/components/image_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();
  final _scrollController = ScrollController();
  final List<String> _imageUrls = [];
  bool _isLoading = false;
  int _currentPage = 0;
  static const int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        for (int i = 0; i < _itemsPerPage; i++) {
          _imageUrls.add("https://picsum.photos/200/300?cacheBuster=${_currentPage * _itemsPerPage + i}");
        }
        _currentPage++;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return DraggableScrollableSheet(
            key: _sheet,
            initialChildSize: 0.3,
            maxChildSize: 0.85,
            minChildSize: 60 / constraints.maxHeight,
            expand: true,
            snap: true,
            snapSizes: [0.3, 0.85],
            controller: _controller,
            builder: (BuildContext context, ScrollController scrollController) {
              return DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _imageUrls.length + 1,
                        itemBuilder: (context, index) {
                          if (index < _imageUrls.length) {
                            return ImageCard(url: _imageUrls[index]);
                          } else if (_isLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                        controller: _scrollController,
                      )
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }
}