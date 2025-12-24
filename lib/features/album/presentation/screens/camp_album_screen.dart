import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/album/domain/entities/album_photo.dart';
import 'package:summercamp/features/album/presentation/state/album_provider.dart';

class CampAlbumScreen extends StatefulWidget {
  final int campId;
  final String campName;

  const CampAlbumScreen({
    super.key,
    required this.campId,
    required this.campName,
  });

  @override
  State<CampAlbumScreen> createState() => _CampAlbumScreenState();
}

class _CampAlbumScreenState extends State<CampAlbumScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlbumProvider>().loadAlbums(widget.campId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Album ảnh ${widget.campName}",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,

          style: const TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            fontSize: 20,
            height: 1.2,
          ),
        ),
        backgroundColor: Color(0xFFF5F7F8),
        foregroundColor: AppTheme.summerPrimary,
        elevation: 0,
      ),
      body: Consumer<AlbumProvider>(
        builder: (context, provider, child) {
          if (provider.loading && provider.albums.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.albums.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Chưa có album ảnh nào",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return DefaultTabController(
            length: provider.albums.length,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppTheme.summerPrimary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppTheme.summerAccent,
                    tabs: provider.albums.map((album) {
                      return Tab(text: album.title);
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: provider.albums.map((album) {
                      return _AlbumPhotoGrid(albumId: album.albumId);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AlbumPhotoGrid extends StatefulWidget {
  final int albumId;

  const _AlbumPhotoGrid({required this.albumId});

  @override
  State<_AlbumPhotoGrid> createState() => _AlbumPhotoGridState();
}

class _AlbumPhotoGridState extends State<_AlbumPhotoGrid>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlbumProvider>().loadPhoto(widget.albumId);
    });
  }

  @override
  bool get wantKeepAlive => true;

  void _viewImage(String imageUrl, String tag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Hero(
              tag: tag,
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(imageUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Selector<AlbumProvider, List<AlbumPhoto>?>(
      selector: (context, provider) =>
          provider.getPhotosByAlbumId(widget.albumId),
      builder: (context, photos, child) {
        if (photos == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (photos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Chưa có ảnh nào",
                  style: TextStyle(fontFamily: "Quicksand", color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            final tag = 'album_view_${photo.photo}_$index';

            return GestureDetector(
              onTap: () => _viewImage(photo.photo, tag),
              child: Hero(
                tag: tag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    photo.photo,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorBuilder: (ctx, err, stack) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
