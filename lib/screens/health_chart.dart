import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HealthChart extends StatelessWidget {
  final List<Map<String, dynamic>> dataList;
  // 每个日期占据的固定宽度（增大默认值，避免日期重叠）
  final double itemWidth;
  // 体温上下浮动范围（比如35-42度，覆盖正常体温+发烧范围）
  final double tempRange = 7;

  const HealthChart({
    super.key,
    required this.dataList,
    this.itemWidth = 40, // 每个日期的宽度
  });

  @override
  Widget build(BuildContext context) {
    // 过滤无效数据（避免空值导致异常）
    final validData = dataList.where((data) =>
    data.containsKey("date") &&
        data.containsKey("temp") &&
        data["temp"] != null &&
        data["temp"] is double
    ).toList();

    print("筛选后的有效数据：$validData");

    if (validData.isEmpty) {
      return const Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text("暂无体温数据")),
        ),
      );
    }

    // 处理数据：提取日期、体温
    List<String> dates = validData.map((e) => e["date"].toString()).toList();
    print("提取的日期列表：$dates");
    List<FlSpot> tempSpots = validData.asMap().entries.map((entry) {
      int index = entry.key;
      double value = entry.value["temp"];
      return FlSpot(index.toDouble(), value);
    }).toList();

    // 动态计算图表宽度：数据量 * 每个日期的固定宽度
    final chartWidth = dates.length * itemWidth;

    // 计算体温的最大值和最小值（用于纵轴范围）
    double maxTemp = tempSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    double minTemp = tempSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b);

    // 纵轴范围：以实际体温范围为中心，扩展一定空间（避免折线贴边）
    double minY = minTemp - 0.5; // 最低值 = 最小体温 - 0.5
    double maxY = maxTemp + 0.5; // 最高值 = 最大体温 + 0.5

    // 确保纵轴范围至少有一定跨度（避免数据太集中导致图表变形）
    if (maxY - minY < 2) {
      final center = (minTemp + maxTemp) / 2;
      minY = center - 1;
      maxY = center + 1;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 300, // 固定图表高度
          child: Scrollbar( // 添加滚动条，提示可滑动
            thumbVisibility: true, // 始终显示滚动条（可选）
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: chartWidth,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      horizontalInterval: 0.5, // 横向网格线每0.5度一条（适配体温精度）
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1, // 每个日期都显示
                          reservedSize: 30, // 预留标签高度（避免文字被截断）
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= dates.length) return const SizedBox.shrink();

                            // 核心修改：处理 2024-01-01T00:00:00.000 格式，提取月-日
                            String originalDate = dates[index];
                            String displayText = "未知日期";

                            try {
                              // 1. 先分割 T，只取前面的日期部分（2024-01-01）
                              String datePart = originalDate.split('T')[0];
                              // 2. 用横杠分割日期部分（["2024", "01", "01"]）
                              List<String> dateParts = datePart.split('-');
                              // 3. 提取月（索引1）和日（索引2），拼接为 "月-日"
                              if (dateParts.length == 3) {
                                String month = dateParts[1]; // 01
                                String day = dateParts[2];   // 01
                                displayText = "$month-$day"; // 最终显示 01-01
                              }
                            } catch (e) {
                              // 解析失败时显示原始日期的前10个字符（避免乱码）
                              displayText = originalDate.substring(0, originalDate.length > 10 ? 10 : originalDate.length);
                            }

                            return Center(
                              child: Text(
                                displayText,
                                style: const TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 0.5, // 纵轴每0.5度显示一个标签（适配体温）
                          reservedSize: 40, // 预留标签宽度（避免文字被截断）
                          getTitlesWidget: (value, meta) {
                            // 格式化体温数值（保留1位小数）
                            return Text(
                              value.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 11),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // showTitles: false 表示隐藏
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    minX: 0,
                    maxX: (validData.length - 1).toDouble(),
                    minY: minY, // 纵轴不从0开始，适配体温范围
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: tempSpots,
                        isCurved: true,
                        color: Colors.redAccent,
                        barWidth: 2.5,
                        dotData: FlDotData(
                          show: true,
                          // dotSize: 4, // 数据点大小
                          // dotColor: Colors.redAccent,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.redAccent.withOpacity(0.1), // 折线下方淡红色填充
                        ),
                      ),
                    ],
                    // 添加数据点点击提示（可选，提升交互）
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: 37.0, // 参考线：正常体温37度
                          color: Colors.orange.withOpacity(0.7),
                          strokeWidth: 1.5,
                          dashArray: [5, 5], // 虚线样式
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}