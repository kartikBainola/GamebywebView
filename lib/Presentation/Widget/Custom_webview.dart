import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final WebViewController controller;
  final bool isLoading;
  final Function() onRefresh;

  const CustomWebView({
    Key? key,
    required this.controller,
    required this.isLoading,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;
  double _dragDistance = 0;
  static const double _refreshThreshold = 100.0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (_isRefreshing) return;

        // Only allow pull to refresh when scrolled to top
        if (_scrollController.position.pixels <= 0) {
          setState(() {
            _dragDistance -= details.delta.dy;
            _dragDistance = _dragDistance.clamp(0.0, _refreshThreshold * 1.5);
          });
        }
      },
      onVerticalDragEnd: (details) async {
        if (_dragDistance >= _refreshThreshold && !_isRefreshing) {
          setState(() {
            _isRefreshing = true;
          });

          await widget.onRefresh();

          setState(() {
            _isRefreshing = false;
            _dragDistance = 0;
          });
        } else {
          setState(() {
            _dragDistance = 0;
          });
        }
      },
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: _dragDistance,
                child: Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: _isRefreshing
                        ? const CircularProgressIndicator()
                        : Icon(
                            Icons.arrow_downward,
                            color: _dragDistance >= _refreshThreshold
                                ? Colors.blue
                                : Colors.grey,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: WebViewWidget(controller: widget.controller),
                  ),
                ),
              ),
            ],
          ),
          if (widget.isLoading && !_isRefreshing)
            const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
