import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/screens/add_detail.dart';
import 'package:favorite_places/screens/place_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreen();
  }
}

class _PlacesScreen extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();

    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider);

    bool isPlaces = places.isNotEmpty;

    void openDetail(String id) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => PlaceDetailsScreen(id: id),
        ),
      );
    }

    void addNewItem() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const AddDetailScreen(),
        ),
      );
    }

    Widget emptyContent = Center(
      child: Text(
        'No places add yet.',
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );

    Widget listContent = FutureBuilder(
      future: _placesFuture,
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundImage: FileImage(places[index].image),
                    ),
                    title: Text(
                      places[index].title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                    ),
                    subtitle: Text(places[index].location.address,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 16,
                            )),
                    onTap: () => openDetail(places[index].id),
                  );
                },
              ),
            ),
    );

    Widget content = isPlaces ? listContent : emptyContent;

    AppBar appBar = AppBar(
      title: const Text('Your places'),
      actions: [
        IconButton(
          onPressed: addNewItem,
          icon: const Icon(Icons.add),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: content,
    );
  }
}
