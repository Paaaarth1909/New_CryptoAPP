import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'news_detail_screen.dart';
import '../services/crypto_news_api_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<CryptoNewsItem> _news = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() => _isLoading = true);
    try {
      final news = await CryptoNewsApiService().fetchNews();
      setState(() {
        _news = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'News Feed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          const NewsSearchBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _news.length,
                    itemBuilder: (context, index) {
                      return NewsCard(news: _news[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class NewsSearchBar extends StatefulWidget {
  const NewsSearchBar({Key? key}) : super(key: key);

  @override
  State<NewsSearchBar> createState() => _NewsSearchBarState();
}

class _NewsSearchBarState extends State<NewsSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  // Example recent searches - will be replaced with actual data later
  final List<String> _recentSearches = [
    'NFT',
    'Binance',
    'Bank of US',
    'Blockchain',
    'Business',
    'NFT Marketplace',
    'Payment',
    'Crypto',
    'Merchants',
    'Supper app',
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  void _onSearchSubmitted(String value) {
    // TODO: Implement search functionality
    _focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your keyword',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Text(
                          'Clear',
                          style: TextStyle(
                            color: Color(0xFF00FFA3),
                            fontSize: 14,
                          ),
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: _onSearchSubmitted,
              onChanged: (value) => setState(() {}),
            ),
          ),
        ),
        if (_showSuggestions)
          Container(
            color: Colors.black,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentSearches.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _recentSearches[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    _searchController.text = _recentSearches[index];
                    _onSearchSubmitted(_recentSearches[index]);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class NewsCard extends StatefulWidget {
  final CryptoNewsItem news;
  const NewsCard({Key? key, required this.news}) : super(key: key);

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isFollowing = false;
  bool isOptionsSheetOpen = false;

  void _toggleOptionsBottomSheet(BuildContext context) {
    if (isOptionsSheetOpen) {
      Navigator.pop(context);
      isOptionsSheetOpen = false;
    } else {
      isOptionsSheetOpen = true;
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionItem(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {
                  Navigator.pop(context);
                  isOptionsSheetOpen = false;
                  _shareNews();
                },
              ),
              _buildOptionItem(
                icon: Icons.person_remove_outlined,
                label: 'Unfollow',
                onTap: () {
                  Navigator.pop(context);
                  isOptionsSheetOpen = false;
                  setState(() {
                    isFollowing = false;
                  });
                },
              ),
              _buildOptionItem(
                icon: Icons.bookmark_border_outlined,
                label: 'Save',
                onTap: () {
                  Navigator.pop(context);
                  isOptionsSheetOpen = false;
                  _saveNews();
                },
              ),
              _buildOptionItem(
                icon: Icons.open_in_browser,
                label: 'Open in browser',
                onTap: () {
                  Navigator.pop(context);
                  isOptionsSheetOpen = false;
                  _openInBrowser();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ).then((_) {
        isOptionsSheetOpen = false;
      });
    }
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareNews() async {
    try {
      await Share.share(
        widget.news.title + '\n' + widget.news.content,
        subject: widget.news.title,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not share news')),
      );
    }
  }

  void _saveNews() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('News saved successfully'),
        backgroundColor: Color(0xFF1E3A2B),
      ),
    );
  }

  void _openInBrowser() async {
    final Uri url = Uri.parse(widget.news.newsImage);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open browser')),
      );
    }
  }

  void _showFollowingNotification(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: const Color(0xFF1E3A2B),
      duration: const Duration(seconds: 3),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Following is success!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Its goal is to show people the stories they care\nabout most, every time they visit.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: const Text(
              'See more',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _toggleFollow(BuildContext context) {
    setState(() {
      isFollowing = !isFollowing;
    });
    if (isFollowing) {
      _showFollowingNotification(context);
    }
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(news: widget.news),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.news.authorImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.news.authorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.news.timeAgo,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _toggleFollow(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? const Color(0xFF00BFB3) : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: isFollowing ? BorderSide.none : const BorderSide(color: Color(0xFF00BFB3)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: TextStyle(
                      color: isFollowing ? Colors.black : const Color(0xFF00BFB3),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () => _toggleOptionsBottomSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.news.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[900],
                image: DecorationImage(
                  image: NetworkImage(widget.news.newsImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Liked by Huoqie and others 1,900',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                '150 responses',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 