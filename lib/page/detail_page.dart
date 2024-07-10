import 'package:flutter/material.dart';
import 'package:test_ta_1/config/app_asset.dart';
import 'package:test_ta_1/config/constants.dart';
// ignore: library_prefixes
import 'package:test_ta_1/model/property.dart' as PropertyModel;
import 'package:test_ta_1/page/schedule_page.dart';
import 'package:test_ta_1/widget/button_custom.dart';
import 'package:test_ta_1/widget/favorite_button.dart';
import 'package:test_ta_1/widget/map_content_detail.dart';

class DetailPage extends StatefulWidget {
  final PropertyModel.Datum property;

  const DetailPage({Key? key, required this.property}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late PropertyModel.Datum propertyData;
  bool isFavorite = false;
  List<Map<String, dynamic>> facilities = [];

  @override
  void initState() {
    super.initState();
    propertyData = widget.property;
    facilities = [
      {
        'icon': AppAsset.iconHome,
        'label': '${propertyData.sqft} sqft',
      },
      {
        'icon': AppAsset.iconGarage,
        'label': '${propertyData.garage} Garage',
      },
      {
        'icon': AppAsset.iconBed,
        'label': '${propertyData.bed} Bed',
      },
      {
        'icon': AppAsset.iconBath,
        'label': '${propertyData.bath} Bath',
      },
      {
        'icon': AppAsset.iconFloor,
        'label': '${propertyData.floor} Floor',
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Property Detail",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: buildBottomNavigationBar(propertyData, context),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            images(),
            const SizedBox(height: 16),
            statHarga(context),
            const SizedBox(height: 5),
            nameLok(context),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                propertyData.description,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Facilities',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            gridfacilities(),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Maps',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            maps(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Padding maps() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        height: 250,
        child: MapContentDetail(
          markerId: propertyData.id,
          latitude: propertyData.latitude,
          longitude: propertyData.longitude,
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar(PropertyModel.Datum property, BuildContext context) {
    if (propertyData.status == 'pending' || propertyData.status == 'sold') {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey[100]!, width: 1.5),
          ),
        ),
        height: 80,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Center(
          child: Text(
            'The Property is Not Available',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey[100]!, width: 1.5),
          ),
        ),
        height: 80,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: ButtonCustom(
          label: 'Set Schedule',
          isExpand: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Schedule(property: propertyData),
              ),
            );
          },
        ),
      );
    }
  }

  GridView gridfacilities() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      itemCount: facilities.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 3,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 162, 162, 162)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(AssetImage(facilities[index]['icon'])),
              const SizedBox(height: 4),
              Text(
                facilities[index]['label'],
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }

  Padding statHarga(BuildContext context) { 
    Color statusColor;
    switch (propertyData.status) {
      case 'ready':
        statusColor = Colors.green;
        break;
      case 'sold':
        statusColor = Colors.red;
        break;
      case 'pending':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    propertyData.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rp.${propertyData.price}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: FavoriteButton(property: propertyData),
          ),
        ],
      ),
    );
  }

  Padding nameLok(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Property Name
        Text(
          propertyData.name,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 3), // Spacing between property name and address
        // Address Row
        Text(
                propertyData.address,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
      ],
    ),
  );
}


  SizedBox images() {
    return SizedBox(
      height: 180,
      child: propertyData.images.isNotEmpty
        ? ListView.builder(
          itemCount: propertyData.images.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                index == 0 ? 16 : 8,
                0,
                index == propertyData.images.length - 1 ? 16 : 8,
                0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  '$baseUrll/storage/images_property/${propertyData.images[index].image}',
                  fit: BoxFit.cover,
                  height: 180,
                  width: 240,
                ),
              ),
            );
          },
        )
        : Center(
          child: Text(
            'No images available',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
    );
  }
}
