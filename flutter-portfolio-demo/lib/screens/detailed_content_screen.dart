import 'package:flutter/material.dart';
import 'package:flutter_portfolio_demo/models/content_type.dart';
import 'package:flutter_portfolio_demo/widgets/app_bar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailedContentScreen extends StatefulWidget {
  final String title;
  final String description;
  final String author;
  final String authorId;
  final ContentType type;
  final String contentUrl;
  final DateTime? createdAt;
  final String? authorAvatarUrl;

  const DetailedContentScreen({
    super.key,
    required this.title,
    required this.description,
    required this.author,
    required this.authorId,
    required this.type,
    required this.contentUrl,
    this.createdAt,
    this.authorAvatarUrl,
  });

  @override
  State<DetailedContentScreen> createState() => _DetailedContentScreenState();
}

class _DetailedContentScreenState extends State<DetailedContentScreen> {
  bool _isDownloading = false;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd.MM.yyyy - HH:mm').format(date);
  }

  Future<void> _downloadContent() async {
    setState(() => _isDownloading = true);
    try {
      // TODO: Download-FunktionalitÃ¤t implementieren
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Download-FunktionalitÃ¤t folgt in KÃ¼rze...'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Download: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModernAppBar(
        title: widget.title,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content Preview (Image / Video / PDF)
            _buildContentPreview(),

            // Content Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Author Information
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: (widget.authorAvatarUrl != null &&
                                widget.authorAvatarUrl!.isNotEmpty)
                            ? NetworkImage(widget.authorAvatarUrl!)
                            : null,
                        child: (widget.authorAvatarUrl == null ||
                                widget.authorAvatarUrl!.isEmpty)
                            ? const Icon(Icons.person, size: 14)
                            : null,
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.author,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (widget.createdAt != null)
                              Text(
                                _formatDate(widget.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Download Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isDownloading ? null : _downloadContent,
                      icon: _isDownloading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : const Icon(Icons.download),
                      label: Text(
                        _isDownloading ? 'downloading...' : 'Download',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPreview() {
    switch (widget.type) {
      case ContentType.image:
        return _buildImagePreview();

      case ContentType.video:
        return _buildVideoPreview();

      case ContentType.pdf:
        return _buildPdfPreview();
    }
  }

  Widget _buildImagePreview() {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Image.network(
          widget.contentUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.image_not_supported,
                  size: 64, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Stack(
      alignment: Alignment.center,
      children: [
        InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(
            child: Image.network(
              widget.contentUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.video_library_outlined,
                      size: 64, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.8),
          ),
          padding: const EdgeInsets.all(16),
          child: const Icon(
            Icons.play_arrow,
            size: 48,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPdfPreview() {
    return Container(
      height: 500,
      width: double.infinity,
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf,
            size: 80,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'PDF Document',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to open in PDF viewer',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _openPdfViewer,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open PDF'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openPdfViewer() async {
    try {
      final url = widget.contentUrl.trim();
      
      // FÃ¼r HTTP/HTTPS URLs - versuche direkt zu Ã¶ffnen
      if (url.startsWith('http://') || url.startsWith('https://')) {
        final uri = Uri.parse(url);
        try {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          return;
        } catch (e) {
          // Fallback bei Fehler
          debugPrint('Error opening HTTP URL: $e');
        }
      }
      
      // FÃ¼r lokale Dateien - versuche mit file:// URI
      if (url.startsWith('/') || url.contains('.pdf')) {
        try {
          final fileUri = Uri.file(url);
          await launchUrl(
            fileUri,
            mode: LaunchMode.externalApplication,
          );
          return;
        } catch (e) {
          debugPrint('Error opening file URI: $e');
        }
      }

      // Universeller Fallback - versuche jeden URL als ist zu Ã¶ffnen
      final uri = Uri.parse(url);
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        return;
      } catch (e) {
        debugPrint('Error with generic URL: $e');
      }

      // Wenn nichts funktioniert, zeige Fehler mit Debug-Info
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open PDF: $url'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}

