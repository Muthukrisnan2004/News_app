import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Sample data for charts and metrics
  final List<MetricCard> _metrics = [
    MetricCard(
      title: 'Total Users',
      value: '24,567',
      icon: Icons.people,
      color: Colors.blue,
    ),
    MetricCard(
      title: 'Active Users',
      value: '15,234',
      icon: Icons.person_outline,
      color: Colors.green,
    ),
    MetricCard(
      title: 'Revenue',
      value: '\$45,678',
      icon: Icons.monetization_on,
      color: Colors.purple,
    ),
    MetricCard(
      title: 'Conversions',
      value: '8.5%',
      icon: Icons.trending_up,
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metrics Grid
              _buildMetricsGrid(),

              SizedBox(height: 20),

              // Section Headers
              _buildSectionHeader('Performance Overview'),

              // Performance Charts
              _buildPerformanceCharts(),

              SizedBox(height: 20),

              _buildSectionHeader('Recent Activities'),

              // Recent Activities List
              _buildRecentActivitiesList(),
            ],
          ),
        ),
      ),
    );
  }

  // Metrics Grid
  Widget _buildMetricsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _metrics.length,
      itemBuilder: (context, index) {
        return _metrics[index];
      },
    );
  }

  // Performance Charts
  Widget _buildPerformanceCharts() {
    return Container(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3),
                FlSpot(1, 2),
                FlSpot(2, 5),
                FlSpot(3, 3.1),
                FlSpot(4, 4),
                FlSpot(5, 3),
                FlSpot(6, 4.5),
              ],
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  // Section Header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Recent Activities List
  Widget _buildRecentActivitiesList() {
    return Card(
      elevation: 4,
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.notifications, color: Colors.blue),
            ),
            title: Text('User Activity $index'),
            subtitle: Text('Description of recent activity'),
            trailing: Text('2h ago'),
          );
        },
      ),
    );
  }
}

// Metric Card Widget
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Icon(icon, color: color),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}