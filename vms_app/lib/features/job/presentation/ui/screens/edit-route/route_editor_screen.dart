import 'package:flutter/material.dart';
import 'package:vms_app/config/theme/app_theme.dart';

class RouteEditorScreen extends StatefulWidget {
  const RouteEditorScreen({Key? key}) : super(key: key);

  @override
  State<RouteEditorScreen> createState() => _RouteEditorScreenState();
}

class _RouteEditorScreenState extends State<RouteEditorScreen> {
  // Time values for each waypoint
  final List<Duration> _times = [
    const Duration(hours: 0, minutes: 8, seconds: 0),
    const Duration(hours: 0, minutes: 8, seconds: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Route'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildWaypoint(
            index: 0,
            icon: Icons.circle_outlined,
            iconColor: Colors.black54,
            address: '120 Hoàng Minh Thảo, Hòa Khá...',
            distance: '8 km',
          ),
          _buildWaypoint(
            index: 1,
            icon: Icons.location_on_outlined,
            iconColor: Colors.black54,
            address: '55 Lê Duẩn, Phường Thạch Qua...',
            distance: '7 km',
          ),
          _buildWaypoint(
            index: 2,
            icon: Icons.location_on,
            iconColor: Colors.red,
            address: '12 Ngô Quyền, Phường An Hải...',
            distance: '',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildWaypoint({
    required int index,
    required IconData icon,
    required Color iconColor,
    required String address,
    required String distance,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: iconColor),
            if (!isLast)
              Container(
                width: 1,
                height: 100,
                color: Colors.grey.withOpacity(0.5),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (distance.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Distance: $distance',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
              if (!isLast) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Time waypoint about: 0h 8m',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                  child: Text(
                    'Time Estimate: 0h 8m',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showCustomTimePicker(context, index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Center(
                            child: Text(
                              _formatDuration(_times[index]),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        child: const Text('Update'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigitHours}h:${twoDigitMinutes}m:${twoDigitSeconds}s";
  }

  void _showCustomTimePicker(BuildContext context, int index) {
    int hours = _times[index].inHours;
    int minutes = _times[index].inMinutes.remainder(60);
    int seconds = _times[index].inSeconds.remainder(60);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    width: double.infinity,
                    child: const Center(
                      child: Text(
                        'Please select the time',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hours
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            diameterRatio: 1.5,
                            onSelectedItemChanged: (int selectedItem) {
                              setState(() {
                                hours = selectedItem;
                              });
                            },
                            controller: FixedExtentScrollController(
                              initialItem: hours,
                            ),
                            physics: const FixedExtentScrollPhysics(),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 24,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                          hours == index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Minutes
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            diameterRatio: 1.5,
                            onSelectedItemChanged: (int selectedItem) {
                              setState(() {
                                minutes = selectedItem;
                              });
                            },
                            controller: FixedExtentScrollController(
                              initialItem: minutes,
                            ),
                            physics: const FixedExtentScrollPhysics(),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 60,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                          minutes == index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Seconds
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            diameterRatio: 1.5,
                            onSelectedItemChanged: (int selectedItem) {
                              setState(() {
                                seconds = selectedItem;
                              });
                            },
                            controller: FixedExtentScrollController(
                              initialItem: seconds,
                            ),
                            physics: const FixedExtentScrollPhysics(),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 60,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                          seconds == index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(color: AppTheme.primaryColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _times[index] = Duration(
                                hours: hours,
                                minutes: minutes,
                                seconds: seconds,
                              );
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(color: AppTheme.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      // Update the state after dialog is closed
      setState(() {});
    });
  }
}
