import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceDetailsScreen extends ConsumerWidget {
  const PlaceDetailsScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Place> places = ref.watch(placesProvider);
    final place = places.firstWhere((it) => it.id == id);
    final lat = place.location.latitude;
    final lng = place.location.longitude;
    final locationImage =
        'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$lat,$lng&key=AIzaSyBZJaSF6D2fnvLNvLmJSXQBtWDwBBStCFQ';
    AppBar appBar = AppBar(
      title: Text(place.title),
    );

    Widget content = Stack(
      children: [
        Image.file(
          place.image,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              GestureDetector(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(locationImage),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => MapScreen(
                        location: place.location,
                        isSelected: false,
                      ),
                    ),
                  );
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black54],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  textAlign: TextAlign.center,
                  place.location.address,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: content,
    );
  }
}
