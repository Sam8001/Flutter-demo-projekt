import 'package:flutter/material.dart';
import '../models/content_type.dart';
import 'package:intl/intl.dart';
import 'package:flutter_portfolio_demo/screens/detailed_content_screen.dart';

class ItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String author;
  final String authorId;
  final ContentType type;
  final String thumbnailUrl; 
  final String contentUrl; 
  final DateTime? createdAt;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final String? authorAvatarUrl;

const ItemWidget({
  super.key,
  required this.title,
  required this.description,
  required this.author,
  required this.authorId,
  required this.type,
  required this.thumbnailUrl,
  required this.contentUrl,
  this.createdAt,
  this.onTap,
  this.onDelete,
  this.authorAvatarUrl,
});

  

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap ?? () => _openDetailedView(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview (Image / PDF / Video)
                _buildPreview(),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Description
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),

                      const SizedBox(height: 12),

                      // Author
                     // Author
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: (authorAvatarUrl != null && (authorAvatarUrl?.isNotEmpty ?? false))
                                ? NetworkImage(authorAvatarUrl!)
                                : null,
                            child: (authorAvatarUrl == null || (authorAvatarUrl?.isEmpty ?? true))
                                ? const Icon(Icons.person, size: 14)
                                : null,
                          ),

                          const SizedBox(width: 8),
                          Text(
                            author,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),


                      const SizedBox(height: 12),

                      // Created At
                      if (createdAt != null)
                        Text(
                          'Erstellt am: ${_formatDate(createdAt)}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Delete Button
          if (onDelete != null)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.red.shade400,
                radius: 18,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openDetailedView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailedContentScreen(
          title: title,
          description: description,
          author: author,
          authorId: authorId,
          type: type,
          contentUrl: contentUrl,
          createdAt: createdAt,
          authorAvatarUrl: authorAvatarUrl,
        ),
      ),
    );
  }

  Widget _buildPreview() {
    switch (type) {
      case ContentType.image:
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.network(
            thumbnailUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );

      case ContentType.video:
        return Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                thumbnailUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const Positioned.fill(
              child: Center(
                child: Icon(Icons.play_circle_fill,
                    size: 64, color: Colors.white),
              ),
            ),
          ],
        );

      case ContentType.pdf:
        return Container(
          height: 180,
          decoration: const BoxDecoration(
            color: Color(0xFFF2F2F2),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: const Center(
            child: Icon(Icons.picture_as_pdf,
                size: 64, color: Colors.red),
          ),
        );
    }
  }
}

