import 'package:flutter/material.dart';
import 'package:test_ta_1/model/property.dart' as PropertyModel;
import 'package:test_ta_1/widget/property_card.dart'; // Import your property card widget

class FilterSuccess extends StatelessWidget {
  final List<PropertyModel.Datum> filteredProperties;
  final String minPrice;
  final String maxPrice;
  final int selectedBedroom;
  final int selectedBathroom;
  final int selectedGarage;

  const FilterSuccess({
    Key? key,
    required this.filteredProperties,
    required this.minPrice,
    required this.maxPrice,
    required this.selectedBedroom,
    required this.selectedBathroom,
    required this.selectedGarage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Filter Success",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: filteredProperties.length,
        itemBuilder: (context, index) {
          PropertyModel.Datum property = filteredProperties[index];
          return PropertyCard(property: property);
        },
      ),
    );
  }
}
