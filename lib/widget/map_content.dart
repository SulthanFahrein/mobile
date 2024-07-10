import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_ta_1/config/app_color.dart';
import 'package:test_ta_1/controller/c_property.dart';
import 'package:test_ta_1/model/property.dart';
import 'package:test_ta_1/widget/property_card.dart';

class MapContent extends StatefulWidget {
  int? markerId;
  late double latitude;
  late double longitude;

  MapContent({Key? key, this.markerId, this.latitude = -6.37426, this.longitude = 106.8337}) : super(key: key);

  @override
  _MapContentState createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  late Future<List<Datum>> _propertiesFuture;
  Datum? _selectedProperty;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = fetchProperties();
  }

  void _selectNextProperty(List<Datum> properties) {
    setState(() {
      _selectedIndex = (_selectedIndex + 1) % properties.length;
      _selectedProperty = properties[_selectedIndex];
      _updateMapPosition(_selectedProperty!.latitude, _selectedProperty!.longitude);
    });
  }

  void _selectPreviousProperty(List<Datum> properties) {
    setState(() {
      _selectedIndex = (_selectedIndex - 1 + properties.length) % properties.length;
      _selectedProperty = properties[_selectedIndex];
      _updateMapPosition(_selectedProperty!.latitude, _selectedProperty!.longitude);
    });
  }

  void _updateMapPosition(double latitude, double longitude) {
    setState(() {
      widget.latitude = latitude;
      widget.longitude = longitude;
    });
  }

  void _closePropertyCard() {
    setState(() {
      _selectedProperty = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final LatLng initialCenter = LatLng(widget.latitude, widget.longitude);
    return GestureDetector(
      onTap: () {
        if (_selectedProperty != null) {
          _closePropertyCard();
        }
      },
      child: SizedBox(
        height: screenHeight,
        child: FutureBuilder<List<Datum>>(
          future: _propertiesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final List<Datum> properties = snapshot.data ?? [];
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_selectedProperty != null) {
                        _closePropertyCard();
                      }
                    },
                    child: FlutterMap(
                      options: MapOptions(
                        center: initialCenter,
                        zoom: 11,
                        interactionOptions: const InteractionOptions(
                          flags: ~InteractiveFlag.doubleTapZoom,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                        ),
                        MarkerLayer(
                          markers: [
                            if (widget.markerId != null)
                              Marker(
                                width: 60,
                                height: 60,
                                point: LatLng(widget.latitude, widget.longitude),
                                child: const Icon(
                                  Icons.location_pin,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              ),
                            ...properties.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final Datum property = entry.value;
                              return Marker(
                                width: _selectedProperty != null && _selectedProperty!.id == property.id ? 80 : 60,
                                height: _selectedProperty != null && _selectedProperty!.id == property.id ? 80 : 60,
                                point: LatLng(property.latitude, property.longitude),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedProperty = property;
                                      _selectedIndex = index;
                                    });
                                  },
                                  child: Icon(
                                    Icons.location_pin,
                                    size: _selectedProperty != null && _selectedProperty!.id == property.id ? 70 : 50,
                                    color: AppColor.primary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_selectedProperty != null)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      left: 0,
                      right: 0,
                      bottom: screenHeight * 0.21, // Adjust based on screen height
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.velocity.pixelsPerSecond.dx > 0) {
                              _selectPreviousProperty(properties);
                            } else if (details.velocity.pixelsPerSecond.dx < 0) {
                              _selectNextProperty(properties);
                            }
                          },
                          child: Dismissible(
                            key: ValueKey(_selectedProperty!.id),
                            direction: DismissDirection.down,
                            onDismissed: (direction) {
                              _closePropertyCard();
                            },
                            child: PropertyCard(property: _selectedProperty!),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
