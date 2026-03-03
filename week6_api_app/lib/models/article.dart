class Article {
  final String title;
  final String description;
  final String? imageUrl; // Nullable – some APIs don't provide image
  final String source;
  final String publishedAt;
  final String url;

  Article({
    required this.title,
    required this.description,
    this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.url,
  });

  // Factory constructor creates Article from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description',
      imageUrl: json['urlToImage'] ?? json['imageUrl'],
      source: json['source'] is Map
          ? (json['source']['name'] ?? 'Unknown')
          : (json['source'] ?? 'Unknown'),
      publishedAt: json['publishedAt'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'source': source,
      'publishedAt': publishedAt,
      'url': url,
    };
  }
}
