import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vms_app/config/theme/app_theme.dart';
import 'package:vms_app/di/injection_container.dart';
import 'package:vms_app/features/job/presentation/cubit/job_cubit.dart';

class RouteEditorScreen extends StatefulWidget {
  const RouteEditorScreen({super.key});

  @override
  State<RouteEditorScreen> createState() => _RouteEditorScreenState();
}

class _RouteEditorScreenState extends State<RouteEditorScreen> {
  final bloc = sl<JobCubit>();
  int? routeId;
  String? token;
  final _logger = Logger();
  late List<Duration> _times;

  @override
  void initState() {
    _getRoute();
    super.initState();
  }

  Future<void> _getRoute() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    routeId = GoRouterState.of(context).extra as int?;

    if (token == null) {
      _logger.e("Token Null");
    } else {
      bloc.getRouteByRouteId(routeId!, token!);
    }
  }

  String formatTime(String time) {
    try {
      final timeValue = int.parse(time.replaceAll(RegExp(r'[^0-9]'), ''));
      final hours = (timeValue / 3600).floor();
      final minutes = ((timeValue % 3600) / 60).floor();
      return '${hours}h ${minutes}m';
    } catch (e) {
      return 'Time not available';
    }
  }

  String formatDistance(int distanceInMeters) {
    double distanceInKilometers = distanceInMeters / 1000.0;
    return '${distanceInKilometers.toStringAsFixed(2)} km';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Route'),
        leading: const BackButton(),
      ),
      body: BlocBuilder<JobCubit, JobState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is JobStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JobStateSuccessRoute) {
            final route = state.success;
            _times =
                route.interconnections
                    .map(
                      (inter) => Duration(seconds: inter.timeEstimate.toInt()),
                    )
                    .toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: route.interconnections.length,
              itemBuilder: (context, index) {
                final waypoint1 = route.waypoints[index];
                final waypoint2 = route.waypoints[index + 1];
                final inter = route.interconnections[index];

                return _buildWaypoint(
                  index: index,
                  interId: inter.interconnectionId,
                  icon: Icons.location_on_outlined,
                  iconColor: Colors.red,
                  address:
                      '${waypoint1.locationName} \n- ${waypoint2.locationName}',
                  distance: inter.distance.toInt(),
                  time: inter.timeWaypoint.toInt(),
                  timeEstimate: _times[index],
                );
              },
            );
          } else if (state is JobStateError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildWaypoint({
    required int index,
    required int interId,
    required IconData icon,
    required Color iconColor,
    required String address,
    required int distance,
    required int time,
    required Duration timeEstimate,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: iconColor),
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
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Distance: ${formatDistance(distance)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Time waypoint about: ${formatTime(time.toString())}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Text(
                  'Time Estimate about: ${_formatDuration(timeEstimate)}',
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
                            _formatDuration(timeEstimate),
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
                      onPressed: () {
                        final newTimeEstimate = _times[index].inSeconds;
                        Map<String, dynamic> formData = {
                          'timeEstimate': newTimeEstimate.toDouble(),
                        };
                        bloc.updateTimeEstimate(
                          routeId!,
                          interId,
                          formData,
                          token!,
                        );
                      },
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
      setState(() {});
    });
  }
}
