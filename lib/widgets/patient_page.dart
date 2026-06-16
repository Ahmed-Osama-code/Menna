import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vigil/widgets/profiles_screen.dart';
import '../controllers/ble_controller.dart';
import 'custom_appbar.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({Key? key}) : super(key: key);

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  final BleController bleController = Get.find<BleController>();

  // Declare reactive lists
  RxList<FlSpot> heartbeatData = <FlSpot>[].obs;
  RxList<FlSpot> bloodPressureData = <FlSpot>[].obs;

  @override
  void initState() {
    super.initState();

    // Initialize heartbeat data using addAll
    heartbeatData.addAll([
      FlSpot(0, 72),
      FlSpot(1, 76),
      FlSpot(2, 88),
      FlSpot(3, 105),
      FlSpot(4, 98),
      FlSpot(5, 112),
    ]);

    // Initialize blood oxygen data using addAll
    bloodPressureData.addAll([
      FlSpot(0, 98),
      FlSpot(1, 97),
      FlSpot(2, 95),
      FlSpot(3, 93),
      FlSpot(4, 92),
      FlSpot(5, 89),
    ]);
  }

  void _updateChartData() {
    // Heartbeat
    if (heartbeatData.length >= 6) heartbeatData.removeAt(0);
    heartbeatData.add(
      FlSpot(
        heartbeatData.isNotEmpty ? heartbeatData.last.x + 1 : 0,
        bleController.heartRate.value.toDouble(),
      ),
    );

    // Blood Oxygen (was bloodPressureData)
    if (bloodPressureData.length >= 6) bloodPressureData.removeAt(0);
    bloodPressureData.add(
      FlSpot(
        bloodPressureData.isNotEmpty ? bloodPressureData.last.x + 1 : 0,
        bleController.bloodOxygen.value.toDouble(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to BLE data changes
    ever(bleController.heartRate, (_) => _updateChartData());
    ever(bleController.bloodOxygen, (_) => _updateChartData());

    return Scaffold(
      appBar: CustomAppBar(
        onESOMPressed: () {
          print('ESOS pressed');
        },
        onNotificationPressed: () {
          print('Notification pressed');
        },
        onMenuPressed: () {
          print('Menu pressed');
        },
        onSearchChanged: (value) {
          print('Search:   $value');
        },
        onFilterPressed: () {
          print('Filter pressed');
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/images/background.png"),
                Row(
                  children: [
                    SizedBox(width: 16),
                    _buildProfileSection(),
                    _buildVitalMetrics(),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
            SizedBox(height: 70),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/mood.svg"),
                      SizedBox(width: 8),
                      Text(
                        'Mood Tracker',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF136A88),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildMoodTrackerChart(),
                ],
              ),
            ),
            SizedBox(height: 50),

            _buildSelfAssessmentSection(),
            SizedBox(height: 40),
            //    SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFD9D9D9DE),
          ),
          child: Center(child: Image.asset("assets/images/avatar.png")),
        ),
        SizedBox(height: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Mohamed Mansour',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF136A88),
              ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF00BFA5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '5 Feb',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVitalMetrics() {
    return SizedBox(
      height: 170,
      width: 238,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: Obx(
              () => statCircle(
                value: "${bleController.fallCount.value}",
                label: "Monthly Fall Count",
              ),
            ),
          ),

          Positioned(
            left: 80,
            top: 65,
            child: Obx(
              () => statCircle(
                value: '${bleController.bloodOxygen.value}%',
                label: "Blood Oxygen\npercentage",
              ),
            ),
          ),

          Positioned(
            right: 0,
            top: 30,
            child: Obx(
              () => statCircle(
                value: '${bleController.heartRate.value}',
                label: "Heart Rate",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statCircle({required String value, required String label}) {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFF28728D), width: 9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Color(0xFFE33629),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0F3B74),
              fontSize: 7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTrackerChart() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Blood Oxygen(%)', Color(0xFF0F3B74)),
                SizedBox(width: 20),
                _buildLegendItem('Heartbeat', Color(0xFFE33629)),
              ],
            ),
          ),
          SizedBox(height: 20),
          Obx(
            () => SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 20,
                    verticalInterval: 10,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey[300]!, strokeWidth: 0.5);
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(color: Colors.grey[300]!, strokeWidth: 0.5);
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                          ];

                          int index = value.toInt(); // 👈 Static mapping

                          if (index >= 0 && index < months.length) {
                            return Text(
                              months[index],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      left: BorderSide(color: Colors.grey[300]!, width: 1),
                      right: const BorderSide(color: Colors.transparent),
                      top: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                  minX: heartbeatData.first.x,
                  maxX: heartbeatData.last.x,
                  minY: 0,
                  maxY: 150,
                  lineBarsData: [
                    // Blood Oxygen Line
                    LineChartBarData(
                      spots: bloodPressureData,
                      isCurved: true,
                      color: Color(0xFF0F3B74),
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Heartbeat Line
                    LineChartBarData(
                      spots: heartbeatData,
                      isCurved: true,
                      color: Color(0xFFE33629),
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildSelfAssessmentSection() {
    return SvgPicture.asset("assets/images/self.svg");
  }
}
