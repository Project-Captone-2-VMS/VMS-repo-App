import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';

class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();

    return Scaffold(
      appBar: AppBar(title: Text("Live Location Sender")),
      body: Center(
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state is LocationInitial) {
              return Text("Press Start to send location.");
            } else if (state is LocationSending) {
              return Text("Sending location every 30s...");
            } else if (state is LocationSent) {
              return Text("Location sent.");
            } else if (state is LocationError) {
              return Text("Error: ${state.message}");
            } else if (state is LocationStopped) {
              return Text("Location sending stopped.");
            } else {
              return Text("Unknown state.");
            }
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'start',
            onPressed: () => cubit.startSendingLocation(),
            child: Icon(Icons.play_arrow),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'stop',
            onPressed: () => cubit.stopSendingLocation(),
            backgroundColor: Colors.red,
            child: Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}
