import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kelime_app/pages/services/statistics_service.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final StatisticsService _statisticsService = StatisticsService();

  int _learnedCount = 0;
  Map<String, int> _dailyCounts = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final learned = await _statisticsService.learnedWordCount();
    final daily = await _statisticsService.dailyCorrectCounts();

    setState(() {
      _learnedCount = learned;
      _dailyCounts = daily;
      _loading = false;
    });
  }

  Future<void> _pdf() async {
    if (_loading) return;

    final pdf = pw.Document();
    final sortedDatas = _dailyCounts.keys.toList()..sort();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Istatistik Raporu',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                ' Ogrendiginiz Toplam Kelime: $_learnedCount',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                ' Son 7 Gunluk Dogru Cevaplar:',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: ['Tarih', 'Dogru Sayisi'],
                data:
                    sortedDatas
                        .map((d) => [d, _dailyCounts[d].toString()])
                        .toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📊 İstatistik"),
        actions: [
          IconButton(
            onPressed: _pdf,
            icon: Icon(Icons.download),
            tooltip: 'PDF Raporu',
          ),
        ],
      ),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _learnedCountCard(),
                    SizedBox(height: 24),
                    Text(
                      "📈 Son 7 Günlük Doğru Cevaplar: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: _dailyCounts.isEmpty ? _emptyState() : _barChar(),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _learnedCountCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.school, color: Colors.blueAccent, size: 40),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Öğrendiğiniz Kelime Sayısı",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "$_learnedCount",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "Henüz Bildiğin Bir Kelime Yok.\nBugün Bir Test Çözmeyi Dene!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _barChar() {
    final dailyCountskey = _dailyCounts.keys.toList()..sort();
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, interval: 1),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index < 0 || index >= dailyCountskey.length) {
                    return SizedBox.shrink();
                  }
                  final date = dailyCountskey[index];
                  final day = date.substring(5);
                  return Text(day, style: TextStyle(fontSize: 10));
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: List.generate(dailyCountskey.length, (index) {
            final count = _dailyCounts[dailyCountskey[index]]!;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: count.toDouble(),
                  width: 18,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
