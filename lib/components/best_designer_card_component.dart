import 'package:flutter/material.dart';

class BestDesignerCard extends StatefulWidget {
  final String name;
  final String sales;
  final double rating;
  final String followers;
  final String imageAsset;
  final VoidCallback? onTap;

  const BestDesignerCard({
    super.key,
    required this.name,
    required this.sales,
    required this.rating,
    required this.followers,
    required this.imageAsset,
    this.onTap,
  });

  @override
  State<BestDesignerCard> createState() => _BestDesignerCardState();
}

class _BestDesignerCardState extends State<BestDesignerCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: 170,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color:
                    _isHovering
                        ? Colors.black.withOpacity(0.4)
                        : Colors.black.withOpacity(0.05),
                blurRadius: _isHovering ? 25 : 8,
                offset: _isHovering ? Offset(0, 15) : Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(widget.imageAsset),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: theme.textTheme.bodyMedium!.fontSize,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.sales, style: theme.textTheme.labelSmall),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.rating.toStringAsFixed(1),
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(width: 8),
                  Text(widget.followers, style: theme.textTheme.labelSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
