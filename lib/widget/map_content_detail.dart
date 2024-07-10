import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_ta_1/config/app_color.dart';
import 'package:test_ta_1/controller/c_property.dart';
import 'package:test_ta_1/model/property.dart';


class MapContentDetail extends StatefulWidget {
  final int? markerId;
  final double? latitude;
  final double? longitude;

  const MapContentDetail({Key? key, this.markerId, this.latitude, this.longitude}) : super(key: key);

  @override
  _MapContentDetailState createState() => _MapContentDetailState();
}

class _MapContentDetailState extends State<MapContentDetail> {
  late Future<List<Datum>> _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final LatLng initialCenter = widget.latitude != null && widget.longitude != null
        ? LatLng(widget.latitude!, widget.longitude!)
        : const LatLng(-6.37426, 106.8337);

    return SizedBox(
      height: screenHeight,
      child: FutureBuilder<List<Datum>>(
        future: _propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<Datum> properties = snapshot.data ?? [];
            return FlutterMap(
              options: MapOptions(
                // ignore: deprecated_member_use
                center: initialCenter,
                // ignore: deprecated_member_use
                zoom: 14,
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
                      ...properties.where((property) => property.id == widget.markerId).map((property) {
                        return Marker(
                          width: 60,
                          height: 60,
                          point: LatLng(property.latitude, property.longitude),
                          child: const Icon(
                            Icons.location_pin,
                            size: 50,
                            color: AppColor.primary, // Customize marker color here
                          ),
                        );
                      })
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
