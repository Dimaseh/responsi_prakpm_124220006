import 'package:flutter/material.dart';
import 'karakter.dart';

class DetailPage extends StatelessWidget {
  final Amiibo amiibo;
  final bool isFavorite;
  final Function(Amiibo) toggleFavorite; // Callback untuk toggle favorit

  const DetailPage({
    Key? key,
    required this.amiibo,
    required this.isFavorite,
    required this.toggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amiibo Details'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              toggleFavorite(amiibo);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Amiibo tanpa Card, hanya Center untuk posisi tengah
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  amiibo.image ?? '',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 100,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Card kedua untuk deskripsi Amiibo
            Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      amiibo.name ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDetailRow('Amiibo Series:', amiibo.amiiboSeries),
                    _buildDetailRow('Character:', amiibo.character),
                    _buildDetailRow('Game Series:', amiibo.gameSeries),
                    _buildDetailRow('Type:', amiibo.type),
                    _buildDetailRow('Head:', amiibo.head),
                    _buildDetailRow('Tail:', amiibo.tail),
                  ],
                ),
              ),
            ),
            // Card ketiga untuk Release Dates
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Release Dates',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildReleaseDate('Australia:', amiibo.release?.au),
                    _buildReleaseDate('Europe:', amiibo.release?.eu),
                    _buildReleaseDate('Japan:', amiibo.release?.jp),
                    _buildReleaseDate('North America:', amiibo.release?.na),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReleaseDate(String region, String? date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            region,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            date ?? '-',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
