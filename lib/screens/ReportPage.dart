// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// // Model class for Report
// class Report {
//   final String title;
//   final String source;
//   final String date;
//   final String category;
//   final int reads;
//   bool saved;
//
//   Report({
//     required this.title,
//     required this.source,
//     required this.date,
//     required this.category,
//     required this.reads,
//     this.saved = false,
//   });
//
//   factory Report.fromJson(Map<String, dynamic> json) {
//     return Report(
//       title: json['title'],
//       source: json['source'],
//       date: json['date'],
//       category: json['category'],
//       reads: json['reads'],
//       saved: json['saved'] ?? false,
//     );
//   }
// }
//
// class ReportsService {
//   static const String baseUrl = 'https://api.newsglobe.com/v1';
//
//   // Fetch reports from API
//   static Future<List<Report>> fetchReports(String type) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/reports?type=$type'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ce4a164333141db490ed9ca70af4c64f', // Replace with actual API key
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body)['data'];
//         return data.map((json) => Report.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load reports: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching reports: $e');
//     }
//   }
//
//   // Toggle save status of a report
//   static Future<bool> toggleSaveReport(String reportId, bool saveStatus) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/reports/$reportId/save'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer YOUR_API_KEY_HERE', // Replace with actual API key
//         },
//         body: json.encode({'saved': saveStatus}),
//       );
//
//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         throw Exception('Failed to update save status: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error updating save status: $e');
//     }
//   }
// }
//
// class ReportsPage extends StatefulWidget {
//   const ReportsPage({Key? key}) : super(key: key);
//
//   @override
//   _ReportsPageState createState() => _ReportsPageState();
// }
//
// class _ReportsPageState extends State<ReportsPage> {
//   int _currentPageIndex = 0;
//   final List<String> _pageLabels = ['Latest Reports', 'Trending', 'Saved'];
//   final List<String> _apiEndpointTypes = ['latest', 'trending', 'saved'];
//
//   List<Report> _reports = [];
//   bool _isLoading = true;
//   String? _errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchReports();
//   }
//
//   Future<void> _fetchReports() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       final reports = await ReportsService.fetchReports(
//         _apiEndpointTypes[_currentPageIndex],
//       );
//
//       setState(() {
//         _reports = reports;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _toggleSaveReport(int index) async {
//     final report = _reports[index];
//     final newSavedStatus = !report.saved;
//
//     // Optimistic update
//     setState(() {
//       _reports[index].saved = newSavedStatus;
//     });
//
//     try {
//       // This is a placeholder since we don't have actual report IDs
//       // In a real app, you would use report.id or similar
//       final success = await ReportsService.toggleSaveReport(
//           'report_${index}',
//           newSavedStatus
//       );
//
//       if (!success) {
//         // Revert if failed
//         setState(() {
//           _reports[index].saved = !newSavedStatus;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update save status')),
//         );
//       }
//     } catch (e) {
//       // Revert on error
//       setState(() {
//         _reports[index].saved = !newSavedStatus;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.grey[900]!,
//               Colors.black,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               _buildPageSelector(),
//               Expanded(
//                 child: RefreshIndicator(
//                   onRefresh: _fetchReports,
//                   backgroundColor: Colors.grey[850],
//                   color: Colors.blue,
//                   child: _isLoading
//                       ? _buildLoadingState()
//                       : _errorMessage != null
//                       ? _buildErrorState()
//                       : _buildReportsList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Reports',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.search, color: Colors.white),
//                 onPressed: () {
//                   // Implement search functionality
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.filter_list, color: Colors.white),
//                 onPressed: () {
//                   // Implement filter functionality
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPageSelector() {
//     return Container(
//       height: 50,
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: _pageLabels.length,
//         itemBuilder: (context, index) {
//           bool isSelected = index == _currentPageIndex;
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _currentPageIndex = index;
//               });
//               _fetchReports();
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//               margin: const EdgeInsets.symmetric(horizontal: 8.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: isSelected
//                     ? LinearGradient(
//                   colors: [Colors.purple, Colors.blue],
//                 )
//                     : null,
//                 color: isSelected ? null : Colors.grey[800],
//               ),
//               child: Center(
//                 child: Text(
//                   _pageLabels[index],
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Center(
//       child: CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//       ),
//     );
//   }
//
//   Widget _buildErrorState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 48,
//               color: Colors.red[400],
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Something went wrong',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               _errorMessage ?? 'Failed to load reports',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.grey[400],
//                 fontSize: 14,
//               ),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _fetchReports,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: Text('Try Again'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildReportsList() {
//     return _reports.isEmpty
//         ? _buildEmptyState()
//         : ListView.builder(
//       padding: const EdgeInsets.all(16.0),
//       itemCount: _reports.length,
//       itemBuilder: (context, index) {
//         final report = _reports[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 16.0),
//           color: Colors.grey[850],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[700],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         report.category,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                     Spacer(),
//                     Icon(
//                       Icons.remove_red_eye_outlined,
//                       size: 16,
//                       color: Colors.grey[400],
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       '${report.reads}',
//                       style: TextStyle(
//                         color: Colors.grey[400],
//                         fontSize: 12,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     GestureDetector(
//                       onTap: () => _toggleSaveReport(index),
//                       child: Icon(
//                         report.saved ? Icons.bookmark : Icons.bookmark_border,
//                         size: 16,
//                         color: report.saved ? Colors.yellow : Colors.grey[400],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   report.title,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Text(
//                       report.source,
//                       style: TextStyle(
//                         color: Colors.grey[400],
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Container(
//                       width: 4,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[400],
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       report.date,
//                       style: TextStyle(
//                         color: Colors.grey[400],
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             _currentPageIndex == 2 ? Icons.bookmark_border : Icons.article_outlined,
//             size: 64,
//             color: Colors.grey[600],
//           ),
//           SizedBox(height: 16),
//           Text(
//             _currentPageIndex == 2
//                 ? 'No saved reports yet'
//                 : 'No reports available',
//             style: TextStyle(
//               color: Colors.grey[400],
//               fontSize: 18,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             _currentPageIndex == 2
//                 ? 'Bookmark reports to find them here'
//                 : 'Check back later for updates',
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart'; // Add this package for connectivity checks

// Model class for Report
class Report {
  final String title;
  final String source;
  final String date;
  final String category;
  final int reads;
  bool saved;

  Report({
    required this.title,
    required this.source,
    required this.date,
    required this.category,
    required this.reads,
    this.saved = false,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      title: json['title'],
      source: json['source'] ?? 'Unknown Source',
      date: json['date'] ?? 'Unknown Date',
      category: json['category'] ?? 'General',
      reads: json['reads'] ?? 0,
      saved: json['saved'] ?? false,
    );
  }
}

class ReportsService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com'; // Use a mock API for testing

  // Mock data for testing
  static Future<List<Report>> fetchMockReports(String type) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      Report(
        title: 'Sample Report 1',
        source: 'News Source A',
        date: '2025-03-31',
        category: 'Technology',
        reads: 150,
      ),
      Report(
        title: 'Sample Report 2',
        source: 'News Source B',
        date: '2025-03-30',
        category: 'Health',
        reads: 200,
      ),
    ];
  }

  // Fetch reports from API
  static Future<List<Report>> fetchReports(String type) async {
    // Check internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection. Please check your network and try again.');
    }

    try {
      // For now, use mock data since the original API doesn't work
      return await fetchMockReports(type);

      // Uncomment this block when you have a working API
      /*
      final response = await http.get(
        Uri.parse('$baseUrl/posts'), // Using jsonplaceholder for testing
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ce4a164333141db490ed9ca70af4c64f',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Map the response to Report objects (jsonplaceholder doesn't match exactly, so this is for demo)
        return data.map((json) => Report(
          title: json['title'] ?? 'Untitled',
          source: 'JSON Placeholder',
          date: '2025-03-31',
          category: type,
          reads: json['id'] * 10, // Fake reads count
        )).toList();
      } else {
        throw Exception('Failed to load reports: ${response.statusCode}');
      }
      */
    } catch (e) {
      throw Exception('Error fetching reports: $e');
    }
  }

  // Toggle save status of a report (mock implementation)
  static Future<bool> toggleSaveReport(String reportId, bool saveStatus) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return true; // Mock success
  }
}

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  int _currentPageIndex = 0;
  final List<String> _pageLabels = ['Latest Reports', 'Trending', 'Saved'];
  final List<String> _apiEndpointTypes = ['latest', 'trending', 'saved'];

  List<Report> _reports = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final reports = await ReportsService.fetchReports(
        _apiEndpointTypes[_currentPageIndex],
      );

      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleSaveReport(int index) async {
    final report = _reports[index];
    final newSavedStatus = !report.saved;

    // Optimistic update
    setState(() {
      _reports[index].saved = newSavedStatus;
    });

    try {
      final success = await ReportsService.toggleSaveReport(
          'report_${index}',
          newSavedStatus
      );

      if (!success) {
        // Revert if failed
        setState(() {
          _reports[index].saved = !newSavedStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update save status')),
        );
      }
    } catch (e) {
      // Revert on error
      setState(() {
        _reports[index].saved = !newSavedStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[900]!,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildPageSelector(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchReports,
                  backgroundColor: Colors.grey[850],
                  color: Colors.blue,
                  child: _isLoading
                      ? _buildLoadingState()
                      : _errorMessage != null
                      ? _buildErrorState()
                      : _buildReportsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Reports',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  // Implement search functionality
                },
              ),
              IconButton(
                icon: Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {
                  // Implement filter functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageSelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _pageLabels.length,
        itemBuilder: (context, index) {
          bool isSelected = index == _currentPageIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentPageIndex = index;
              });
              _fetchReports();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: isSelected
                    ? LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                )
                    : null,
                color: isSelected ? null : Colors.grey[800],
              ),
              child: Center(
                child: Text(
                  _pageLabels[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
            SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Failed to load reports',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchReports,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    return _reports.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _reports.length,
      itemBuilder: (context, index) {
        final report = _reports[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          color: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        report.category,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.remove_red_eye_outlined,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${report.reads}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _toggleSaveReport(index),
                      child: Icon(
                        report.saved ? Icons.bookmark : Icons.bookmark_border,
                        size: 16,
                        color: report.saved ? Colors.yellow : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  report.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      report.source,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      report.date,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _currentPageIndex == 2 ? Icons.bookmark_border : Icons.article_outlined,
            size: 64,
            color: Colors.grey[600],
          ),
          SizedBox(height: 16),
          Text(
            _currentPageIndex == 2
                ? 'No saved reports yet'
                : 'No reports available',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _currentPageIndex == 2
                ? 'Bookmark reports to find them here'
                : 'Check back later for updates',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}