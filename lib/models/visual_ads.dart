class VisualAd {
  final String id;
  final String title;
  final String imagePath; // Path relative to assets/ or full path
  final String category; // Category/slide name for filtering
  final DateTime createdAt;

  const VisualAd({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.category,
    required this.createdAt,
  });

  VisualAd copyWith({
    String? id,
    String? title,
    String? imagePath,
    String? category,
    DateTime? createdAt,
  }) {
    return VisualAd(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisualAd &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}