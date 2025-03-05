class NewsArticle {
  final String title;
  final String description;
  final String imageUrl;
  final String articleUrl;

  NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.articleUrl,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      articleUrl: json['url'] ?? '',
    );
  }
}