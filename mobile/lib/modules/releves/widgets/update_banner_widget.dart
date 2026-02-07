import 'package:flutter/material.dart';
import '../../../services/github_update_service.dart';
import '../../../utils/mixins/mixins.dart';

/// Widget bannière pour afficher les mises à jour disponibles
class UpdateBannerWidget extends StatefulWidget {
  final UpdateInfo updateInfo;
  final VoidCallback onDismiss;

  const UpdateBannerWidget({
    super.key,
    required this.updateInfo,
    required this.onDismiss,
  });

  @override
  State<UpdateBannerWidget> createState() => _UpdateBannerWidgetState();
}

class _UpdateBannerWidgetState extends State<UpdateBannerWidget>
    with SingleTickerProviderStateMixin, AnimationStyleMixin {
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: fastDuration,
  );

  @override
  void initState() {
    super.initState();
    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isForceUpdate = widget.updateInfo.forceUpdate;
    final bgColor = isForceUpdate ? Colors.red.shade700 : Colors.blue.shade600;

    final fade = buildStaggeredFade(_introController, 0);
    final slide = buildStaggeredSlide(fade);

    return buildFadeSlide(
      fade: fade,
      slide: slide,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: bgColor,
        child: Row(
          children: [
            Icon(
              isForceUpdate ? Icons.warning_amber_rounded : Icons.system_update,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isForceUpdate ? '⚠️ Mise à jour requise' : '📦 Mise à jour disponible',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'v${widget.updateInfo.currentVersion} → v${widget.updateInfo.latestVersion}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    GitHubUpdateService().downloadUpdate(context, widget.updateInfo.downloadUrl);
                  },
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Télécharger'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: bgColor,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                if (!isForceUpdate) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    iconSize: 20,
                    onPressed: widget.onDismiss,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
