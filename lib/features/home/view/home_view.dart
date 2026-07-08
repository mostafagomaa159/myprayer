import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:myprayer/features/home/view_model/home_cubit.dart';
import 'package:myprayer/features/home/view_model/home_state.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Time Alerts'),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            // Display the prayer times
            final prayerTimes = state.prayerTimes;
            return ListView(
              children: prayerTimes.entries.map((entry) {
                return ListTile(
                  title: Text('${entry.key}: ${entry.value}'),
                );
              }).toList(),
            );
          }
          return Center(child: Text('Press the button to fetch prayer times.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HomeCubit>().fetchAndScheduleAlerts();
        },
        child: Icon(Icons.notifications),
      ),
    );
  }
}
