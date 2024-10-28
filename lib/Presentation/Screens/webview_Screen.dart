import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Data/game_repo.dart';
import '../providers/webview_provider.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  final platforms = GameRepository().getPlatforms();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
    _controller.clearCache();
  }

  void _initWebView() {
    final provider = Provider.of<WebViewProvider>(context, listen: false);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            provider.setLoading(true);
            provider.setError(null);
          },
          onPageFinished: (String url) {
            provider.setLoading(false);
          },
          onWebResourceError: (WebResourceError error) {
            provider.setLoading(false);
            provider.setError('Failed to load page: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(provider.currentUrl));
  }

  Future<void> _handleRefresh() async {
    final provider = Provider.of<WebViewProvider>(context, listen: false);

    try {
      _isRefreshing = true;
      // Show a snackbar to indicate refresh is in progress
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Refreshing page...'),
          duration: Duration(seconds: 1),
        ),
      );

      await _controller.reload();

      // Check if the page loaded successfully
      final response = await _controller
          .runJavaScriptReturningResult('document.readyState') as String;

      if (response != '"complete"') {
        throw Exception('Page did not load completely');
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Page refreshed successfully'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Handle any errors during refresh
      if (mounted) {
        provider.setError('Failed to refresh: ${e.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to refresh page'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        _isRefreshing = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gaming Platform'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _handleRefresh,
          ),
          PopupMenuButton<String>(
            onSelected: (url) {
              Provider.of<WebViewProvider>(context, listen: false).setUrl(url);
              _controller.loadRequest(Uri.parse(url));
            },
            itemBuilder: (BuildContext context) {
              return platforms.map((platform) {
                return PopupMenuItem<String>(
                  value: platform.url,
                  child: Text(platform.name),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Consumer<WebViewProvider>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  ElevatedButton(
                    onPressed: () {
                      provider.setError(null);
                      _controller.reload();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: _handleRefresh,
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                child: WebViewWidget(controller: _controller),
              ),
              if (provider.isLoading) const LinearProgressIndicator(),
            ],
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../../Data/game_repo.dart';
// import '../Widget/Custom_webview.dart';
// import '../Widget/smooth_scrolling.dart';
// import '../providers/webview_provider.dart';
//
// class WebViewScreen extends StatefulWidget {
//   const WebViewScreen({Key? key}) : super(key: key);
//
//   @override
//   _WebViewScreenState createState() => _WebViewScreenState();
// }
//
// class _WebViewScreenState extends State<WebViewScreen> {
//   late WebViewController _controller;
//   final platforms = GameRepository().getPlatforms();
//   bool _isRefreshing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initWebView();
//   }
//
//   void _initWebView() {
//     final provider = Provider.of<WebViewProvider>(context, listen: false);
//
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             if (!_isRefreshing) {
//               provider.setLoading(true);
//             }
//             provider.setError(null);
//           },
//           onPageFinished: (String url) {
//             provider.setLoading(false);
//             _isRefreshing = false;
//           },
//           onWebResourceError: (WebResourceError error) {
//             provider.setLoading(false);
//             _isRefreshing = false;
//             provider.setError('Failed to load page: ${error.description}');
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(provider.currentUrl));
//   }
//
//   Future<void> _handleRefresh() async {
//     final provider = Provider.of<WebViewProvider>(context, listen: false);
//
//     try {
//       _isRefreshing = true;
//       // Show a snackbar to indicate refresh is in progress
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Refreshing page...'),
//           duration: Duration(seconds: 1),
//         ),
//       );
//
//       await _controller.reload();
//
//       // Check if the page loaded successfully
//       final response = await _controller
//           .runJavaScriptReturningResult('document.readyState') as String;
//
//       if (response != '"complete"') {
//         throw Exception('Page did not load completely');
//       }
//
//       // Show success message
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Page refreshed successfully'),
//             duration: Duration(seconds: 1),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       // Handle any errors during refresh
//       if (mounted) {
//         provider.setError('Failed to refresh: ${e.toString()}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to refresh page'),
//             duration: Duration(seconds: 2),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         _isRefreshing = false;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gaming Platform'),
//         actions: [
//           // Explicit refresh button in app bar
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _handleRefresh,
//           ),
//           PopupMenuButton<String>(
//             onSelected: (url) {
//               Provider.of<WebViewProvider>(context, listen: false).setUrl(url);
//               _controller.loadRequest(Uri.parse(url));
//             },
//             itemBuilder: (BuildContext context) {
//               return platforms.map((platform) {
//                 return PopupMenuItem<String>(
//                   value: platform.url,
//                   child: Text(platform.name),
//                 );
//               }).toList();
//             },
//           ),
//         ],
//       ),
//       body: Consumer<WebViewProvider>(
//         builder: (context, provider, child) {
//           if (provider.error != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     provider.error!,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       provider.setError(null);
//                       _controller.reload();
//                     },
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return Stack(
//             children: [
//               RefreshIndicator(
//                 onRefresh: _handleRefresh,
//                 child: Stack(
//                   children: [
//                     WebViewWidget(controller: _controller),
//                     // This ensures RefreshIndicator works with WebView
//                     ListView(
//                       scrollDirection: Axis.vertical,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       children: const [
//                         SizedBox(height: 1),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               if (provider.isLoading && !_isRefreshing)
//                 const LinearProgressIndicator(),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// // class WebViewScreen extends StatefulWidget {
// //   const WebViewScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   _WebViewScreenState createState() => _WebViewScreenState();
// // }
// //
// // class _WebViewScreenState extends State<WebViewScreen> {
// //   late WebViewController _controller;
// //   final platforms = GameRepository().getPlatforms();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initWebView();
// //   }
// //
// //   void _initWebView() {
// //     final provider = Provider.of<WebViewProvider>(context, listen: false);
// //
// //     _controller = WebViewController()
// //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
// //       ..setNavigationDelegate(
// //         NavigationDelegate(
// //           onPageStarted: (String url) {
// //             provider.setLoading(true);
// //             provider.setError(null);
// //           },
// //           onPageFinished: (String url) {
// //             provider.setLoading(false);
// //           },
// //           onWebResourceError: (WebResourceError error) {
// //             provider.setLoading(false);
// //             provider.setError('Failed to load page: ${error.description}');
// //             _showErrorSnackBar(error.description);
// //           },
// //         ),
// //       )
// //       ..loadRequest(Uri.parse(provider.currentUrl));
// //   }
// //
// //   Future<void> _handleRefresh() async {
// //     try {
// //       await _controller.reload();
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Page refreshed'),
// //             duration: Duration(seconds: 1),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         _showErrorSnackBar('Failed to refresh page');
// //       }
// //     }
// //   }
// //
// //   void _showErrorSnackBar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         duration: const Duration(seconds: 3),
// //         backgroundColor: Colors.red,
// //         action: SnackBarAction(
// //           label: 'Retry',
// //           textColor: Colors.white,
// //           onPressed: _handleRefresh,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Gaming Platform'),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.refresh),
// //             onPressed: _handleRefresh,
// //           ),
// //           PopupMenuButton<String>(
// //             onSelected: (url) {
// //               Provider.of<WebViewProvider>(context, listen: false).setUrl(url);
// //               _controller.loadRequest(Uri.parse(url));
// //             },
// //             itemBuilder: (BuildContext context) {
// //               return platforms.map((platform) {
// //                 return PopupMenuItem<String>(
// //                   value: platform.url,
// //                   child: Text(platform.name),
// //                 );
// //               }).toList();
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Consumer<WebViewProvider>(
// //         builder: (context, provider, child) {
// //           if (provider.error != null) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Text(
// //                     provider.error!,
// //                     textAlign: TextAlign.center,
// //                     style: const TextStyle(color: Colors.red),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   ElevatedButton.icon(
// //                     onPressed: () {
// //                       provider.setError(null);
// //                       _controller.reload();
// //                     },
// //                     icon: const Icon(Icons.refresh),
// //                     label: const Text('Retry'),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }
// //
// //           return CustomWebView(
// //             controller: _controller,
// //             isLoading: provider.isLoading,
// //             onRefresh: _handleRefresh,
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
