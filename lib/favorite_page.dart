import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'karakter.dart';

class FavoritePage extends StatelessWidget {
  final Set<Amiibo> favoriteAmiibos;
  final Function(Amiibo) toggleFavorite;
  final Function(Amiibo) removeFavorite; // Callback untuk menghapus favorit

  const FavoritePage({
    Key? key,
    required this.favoriteAmiibos,
    required this.toggleFavorite,
    required this.removeFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favoriteAmiibos.isEmpty
          ? const Center(
              child: Text(
                'No favorites added yet!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favoriteAmiibos.length,
              itemBuilder: (context, index) {
                final amiibo = favoriteAmiibos.elementAt(index);
                return Dismissible(
                  key: Key(amiibo.name ?? 'default_key'),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    removeFavorite(amiibo);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('${amiibo.name} telah dihapus dari favorit'),
                        backgroundColor: Colors
                            .redAccent, // Atur warna latar belakang SnackBar
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4,
                    child: ListTile(
                      leading: Image.network(
                        amiibo.image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 50);
                        },
                      ),
                      title: Text(amiibo.name!),
                      subtitle: Text(amiibo.gameSeries!),
                      trailing: IconButton(
                        icon: Icon(
                          favoriteAmiibos.contains(amiibo)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () => toggleFavorite(amiibo),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              amiibo: amiibo,
                              isFavorite: favoriteAmiibos.contains(amiibo),
                              toggleFavorite: toggleFavorite,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
