import 'package:flutter/material.dart';
import 'package:news_app/news_article/news_api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import '../services/news_api_service.dart';
import '../models/news_article.dart';

class CategoryNewsScreen extends StatefulWidget {
  final String category;

  const CategoryNewsScreen({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryNewsScreenState createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends State<CategoryNewsScreen> {
  late Future<List<NewsArticle>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = NewsApiService().fetchNewsByCategory(widget.category);
  }

  void _openArticle(BuildContext context, String url) {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('News Article')),
          body: WebViewWidget(controller: controller),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category.toUpperCase()} News'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading news'));
          }

          final articles = snapshot.data!;

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: article.imageUrl != null
                      ? Image.network(
                    article.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : null,
                  title: Text(article.title),
                  subtitle: Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _openArticle(context, article.articleUrl),
                ),
              );
            },
          );
        },
      ),
    );
  }
}