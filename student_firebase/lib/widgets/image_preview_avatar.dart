import 'package:flutter/material.dart';

class ImagePreviewAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const ImagePreviewAvatar({
    super.key,
    required this.imageUrl,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0x4D6366F1),
        child: CircleAvatar(
          radius: radius - 3,
          backgroundColor: const Color(0xFFEEF2F6),
          child: ClipOval(
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: (radius - 3) * 2,
                    height: (radius - 3) * 2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image_outlined,
                      size: radius * 0.65,
                      color: Colors.redAccent,
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Color(0xFF6366F1),
                        ),
                      );
                    },
                  )
                : Icon(
                    Icons.account_circle_outlined,
                    size: radius * 0.85,
                    color: const Color(0xFF6366F1),
                  ),
          ),
        ),
      ),
    );
  }
}
