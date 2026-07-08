

import 'package:flutter/material.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Map<String, dynamic> prayerTimes;
  HomeLoaded(this.prayerTimes);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
