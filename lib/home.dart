import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_network.dart';
import 'karakter.dart';
import 'detail_page.dart';
import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Amiibo>> futureAmiibos;
  final Set<Amiibo> _favoriteAmiibos = {};
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureAmiibos = ApiService().fetchAmiibos();
    _loadFavorites();
  }

  // Fungsi untuk menambah atau menghapus dari daftar favorit
  void _toggleFavorite(Amiibo amiibo) {
    setState(() {
      if (_favoriteAmiibos.contains(amiibo)) {
        _favoriteAmiibos.remove(amiibo);
        _showSnackBar("${amiibo.name ?? 'Amiibo'} telah dihapus dari favorit",
            Colors.redAccent);
      } else {
        _favoriteAmiibos.add(amiibo);
      }
      _saveFavorites();
    });
  }

  void _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds =
        _favoriteAmiibos.map((amiibo) => amiibo.tail!).toList();
    prefs.setStringList('favoriteAmiibos', favoriteIds);
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favoriteAmiibos');
    if (favoriteIds != null) {
      List<Amiibo> allAmiibos =
          await ApiService().fetchAmiibos(); // Ambil data semua amiibo
      setState(() {
        _favoriteAmiibos.addAll(
            allAmiibos.where((amiibo) => favoriteIds.contains(amiibo.tail!)));
      });
    }
  }

  // Menampilkan SnackBar
  void _showSnackBar(String message, Color backgroundColor) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Halaman utama
  Widget _buildHomePage() {
    return FutureBuilder<List<Amiibo>>(
      future: futureAmiibos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else if (snapshot.hasData) {
          final amiibos = snapshot.data!;

          for (var amiibo in amiibos) {
            if (_favoriteAmiibos.any((fav) => fav.tail == amiibo.tail)) {
              _favoriteAmiibos.add(amiibo);
            }
          }

          return ListView.builder(
            itemCount: amiibos.length,
            itemBuilder: (context, index) {
              final amiibo = amiibos[index];
              return Card(
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
                  title: Text(
                    amiibo.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(amiibo.gameSeries!),
                  trailing: IconButton(
                    icon: Icon(
                      _favoriteAmiibos.contains(amiibo)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () => _toggleFavorite(amiibo),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          amiibo: amiibo,
                          isFavorite: _favoriteAmiibos.contains(amiibo),
                          toggleFavorite: _toggleFavorite,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text('No data available.'),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0
            ? const Text('Nintendo Amiibo List') // Teks untuk halaman utama
            : const Text('Favorites'), // Teks untuk halaman favorit
        centerTitle: true,
      ),
      body: _selectedIndex == 0
          ? _buildHomePage()
          : FavoritePage(
              favoriteAmiibos: _favoriteAmiibos,
              toggleFavorite: _toggleFavorite,
              removeFavorite: (amiibo) {
                setState(() {
                  _favoriteAmiibos
                      .remove(amiibo); // Menghapus item dari daftar favorit
                  _saveFavorites(); // Simpan perubahan ke SharedPreferences
                });
              },
            ), // Panggil FavoritePage dengan parameter removeFavorite
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
