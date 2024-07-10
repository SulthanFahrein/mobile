import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_ta_1/controller/c_favorite.dart';
import 'package:test_ta_1/controller/sessionProvider.dart';
import 'package:test_ta_1/model/property.dart' as PropertyModel;

class FavoriteButton extends StatefulWidget {
  final PropertyModel.Datum property;

  const FavoriteButton({Key? key, required this.property}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = false;
    loadFavoriteStatus();
  }

  Future<void> loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('favorite_${widget.property.id}') ?? false;
    });
  }

  void _handleFavorite() async {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    final user = sessionProvider.user;

    if (user == null) {
      print('User is not logged in');
      return;
    }

    final controller = FavoriteController();
    try {
      if (isFavorite) {
        final favorites =
            await controller.getFavorite(user.idUser ?? 0);
        final favoriteToDelete = favorites.firstWhere(
          (favorite) => favorite['id_properti'] == widget.property.id,
          orElse: () => null,
        );

        if (favoriteToDelete != null) {
          await controller.deleteFavorite(
              favoriteToDelete['id_favorite']);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Removed from favorites')),
          );
        } else {
          print('Favorite not found');
        }
      } else {

        await controller.postFavorite(
          idPengguna: user.idUser ?? 0,
          idProperti: widget.property.id,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
      }

      // Save favorite status to shared preferences
      SharedPreferences prefs =
          await SharedPreferences.getInstance();
      await prefs.setBool(
          'favorite_${widget.property.id}', !isFavorite);

      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _handleFavorite,
      icon: Icon(
        Icons.favorite,
        size: 45,
        color: isFavorite
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
      iconSize: 30,
    );
  }
}
