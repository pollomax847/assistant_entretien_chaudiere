import 'package:flutter/material.dart';

/// Mixin pour gérer la pagination des formulaires 3-pages
mixin PaginationMixin<T extends StatefulWidget> on State<T> {
  late PageController pageController;
  int currentPage = 0;
  final int totalPages = 3;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// Va à la page spécifiée
  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => currentPage = page);
    }
  }

  /// Va à la page suivante
  void nextPage() {
    if (currentPage < totalPages - 1) {
      goToPage(currentPage + 1);
    }
  }

  /// Va à la page précédente
  void previousPage() {
    if (currentPage > 0) {
      goToPage(currentPage - 1);
    }
  }

  /// Vérifie si on est sur la première page
  bool isFirstPage() => currentPage == 0;

  /// Vérifie si on est sur la dernière page
  bool isLastPage() => currentPage == totalPages - 1;

  /// Construit l'indicateur de progression (dots)
  Widget buildPageIndicator() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalPages,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index ? Colors.indigo : Colors.grey[300],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construit le titre avec numéro de page
  Widget buildPageHeader(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      'Page ${currentPage + 1}/$totalPages',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          buildPageIndicator(),
        ],
      ),
    );
  }

  /// Construit la barre de progression
  Widget buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: (currentPage + 1) / totalPages,
          minHeight: 6,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
        ),
      ),
    );
  }
}
