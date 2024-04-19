import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:async_tools/async_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show Platform;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/theme.dart';

class BlogPost {
  final String title;
  final String author;

  final String content;
  final bool owned;

  BlogPost({
    required this.title,
    required this.author,
    required this.content,
    this.owned = false,
  });
}

class BlogCubit extends Cubit<BlogPost?> {
  BlogCubit() : super(null);

  void setActiveBlog(BlogPost blogPost) => emit(blogPost);
}


class BlogPostDetailsScreen extends StatelessWidget {
  final BlogPost blogPost;

  const BlogPostDetailsScreen({Key? key, required this.blogPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(blogPost.title)),
      body: Markdown(data: blogPost.content),
    );
  }
}

class BlogPostEditor extends StatefulWidget {
  final Function(String) onSave;

  const BlogPostEditor({Key? key, required this.onSave}) : super(key: key);

  @override
  _BlogPostEditorState createState() => _BlogPostEditorState();
}

class _BlogPostEditorState extends State<BlogPostEditor> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Post Editor'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              widget.onSave(_contentController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: _contentController,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Enter your blog content here...',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}


class BlogPostItemWidget extends StatelessWidget {
  final BlogPost blogPost;

  const BlogPostItemWidget({Key? key, required this.blogPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return styledBlogPostTile(context, blogPost);
  }

  Widget styledBlogPostTile(BuildContext context, BlogPost blogPost) {
    final theme = Theme.of(context);
    final scale = theme.extension<ScaleScheme>()!;
    
    return DecoratedBox(
      decoration: BoxDecoration(
        color: blogPost.owned ? scale.primaryScale.subtleBackground : scale.secondaryScale.subtleBackground,
        border: Border.all(color: scale.primaryScale.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SliderTile(
        disabled: false, // Assuming that disabled state is controlled externally
        selected: false, // Manage selection state if needed
        tileScale: ScaleKind.primary, // Adjust based on your theme settings
        title: blogPost.title,
        subtitle: blogPost.owned ? "Owned By You" : "From ${blogPost.author}",
        icon: Icons.book,
        onTap: () {
          context.read<BlogCubit>().setActiveBlog(blogPost);
          if (!kIsWeb) { if (Platform.isIOS || Platform.isAndroid) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlogPostDetailsScreen(blogPost: blogPost),
              ),
            );
          } }
        },
        endActions: [
          if (blogPost.owned) SliderTileAction(
            icon: Icons.delete,
            label: 'Delete',
            actionScale: ScaleKind.tertiary,
            onPressed: (BuildContext context) {
              // Implement your deletion logic here
            },
          ),
          if (!blogPost.owned) SliderTileAction(
            icon: Icons.block,
            label: 'Block',
            actionScale: ScaleKind.tertiary,
            onPressed: (BuildContext context) {
              // Implement your deletion logic here
            },
          ),
          SliderTileAction(
            icon: Icons.share,
            label: 'Share',
            actionScale: ScaleKind.tertiary,
            onPressed: (BuildContext context) {
              // Implement your share logic here
            },
          ),
        ],
    ));
  }
}


class SearchableBlogPostListWidget extends StatefulWidget {
  final List<BlogPost> blogPosts;

  const SearchableBlogPostListWidget({Key? key, required this.blogPosts}) : super(key: key);

  @override
  _SearchableBlogPostListWidgetState createState() => _SearchableBlogPostListWidgetState();
}

class _SearchableBlogPostListWidgetState extends State<SearchableBlogPostListWidget> {
  TextEditingController _searchController = TextEditingController();
  List<BlogPost> _filteredPosts = [];

  @override
  void initState() {
    super.initState();
    _filteredPosts = widget.blogPosts; // Start with all posts
  }

  void _filterPosts(String enteredKeyword) {
    List<BlogPost> results = [];
    if (enteredKeyword.isEmpty) {
      results = widget.blogPosts;
    } else {
      results = widget.blogPosts.where((post) =>
          post.title.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
          post.author.toLowerCase().contains(enteredKeyword.toLowerCase())
      ).toList();
    }
    setState(() {
      _filteredPosts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return styledTitleContainer(
      context: context,
      title: "Searchable Blog Posts",
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _filterPosts,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPosts.length,
              itemBuilder: (context, index) {
                return BlogPostItemWidget(blogPost: _filteredPosts[index]).paddingLTRB(0, 4, 0, 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}