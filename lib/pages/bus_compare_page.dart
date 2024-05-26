import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import '/services/thing_speak_service.dart';
import '/util/location_util.dart';
import 'bus_list_page.dart';

class BusComparePage extends StatelessWidget {
  final String destination;
  final double startLatitude;
  final double startLongitude;
  final List<Bus> availableBuses;

  BusComparePage({
    super.key,
    required this.destination,
    required this.startLatitude,
    required this.startLongitude,
    required this.availableBuses,
  });

  Future<List<Map<String, dynamic>>> _fetchAllBusData() async {
    List<Map<String, dynamic>> busDataList = [];
    ThingSpeakService thingSpeakService = ThingSpeakService();

    for (var bus in availableBuses) {
      try {
        var busData =
            await thingSpeakService.fetchLatestData(bus.channelId, bus.apiKey);
        busData['id'] = bus.id; // Add bus ID to the data
        busDataList.add(busData);
      } catch (e) {
        // Handle the error if needed
      }
    }

    return busDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAllBusData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final busDataList = snapshot.data!;
            final approachingBuses = busDataList.where((busData) {
              final currentDistance = LocationUtils.calculateDistance(
                busData['currentLatitude'],
                busData['currentLongitude'],
                startLatitude,
                startLongitude,
              );
              final previousDistance = LocationUtils.calculateDistance(
                busData['previousLatitude'],
                busData['previousLongitude'],
                startLatitude,
                startLongitude,
              );
              return previousDistance > currentDistance;
            }).toList();

            if (approachingBuses.isEmpty) {
              return const Center(
                  child: Text(
                      'No bus is approaching you, please check back later.'));
            }

            approachingBuses.sort((a, b) {
              final distanceA = LocationUtils.calculateDistance(
                a['currentLatitude'],
                a['currentLongitude'],
                startLatitude,
                startLongitude,
              );
              final distanceB = LocationUtils.calculateDistance(
                b['currentLatitude'],
                b['currentLongitude'],
                startLatitude,
                startLongitude,
              );
              return distanceA.compareTo(distanceB);
            });

            final closestBus = approachingBuses.first;
            final closestBusDistance = LocationUtils.calculateDistance(
              closestBus['currentLatitude'],
              closestBus['currentLongitude'],
              startLatitude,
              startLongitude,
            );
            final closestBusETA = LocationUtils.calculateETA(
              closestBusDistance,
              closestBus['currentSpeed'],
            );

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Recommended Bus ID: ${closestBus['id']}'),
                  const SizedBox(height: 10),
                  Text(
                      'Distance to bus: ${closestBusDistance.toStringAsFixed(2)} km'),
                  const SizedBox(height: 10),
                  Text(
                      'Estimated time of arrival: ${closestBusETA.toStringAsFixed(2)} hours'),
                  const SizedBox(height: 10),
                  const Text('The bus is approaching you.'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
