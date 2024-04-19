import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:async_tools/async_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../theme/theme.dart';

class MapLocation {
  final String name;
  final String coordinates;

  MapLocation({required this.name, required this.coordinates});
}

class User {
  final String name;
  final String pubkey;

  User({required this.name, required this.pubkey});
}

class MapLocationItemWidget extends StatelessWidget {
  final MapLocation location;

  const MapLocationItemWidget({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return styledMapLocationTile(context, location);
  }

  Widget styledMapLocationTile(BuildContext context, MapLocation location) {
    final theme = Theme.of(context);
    final scale = theme.extension<ScaleScheme>()!;
    
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scale.primaryScale.subtleBackground,
        border: Border.all(color: scale.primaryScale.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SliderTile(
        disabled: false, // Assuming that disabled state is controlled externally
        selected: false, // Manage selection state if needed
        tileScale: ScaleKind.primary, // Adjust based on your theme settings
        title: location.name,
        subtitle: "Coordinates: ${location.coordinates}",
        icon: Icons.location_on,
        onTap:() async {
            if (!kIsWeb) { if (Platform.isIOS || Platform.isAndroid) { await GoRouterHelper(context).push('/map'); } } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text("Selected Location: ${location.name} (${location.coordinates})"),
                ),
              );
            };
          },
          
        endActions: [
          SliderTileAction(
            icon: Icons.delete,
            label: 'Delete',
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

class UserItemWidget extends StatelessWidget {
  final User user;

  const UserItemWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return styledUserTile(context, user);
  }

  Widget styledUserTile(BuildContext context, User user) {
    final theme = Theme.of(context);
    final scale = theme.extension<ScaleScheme>()!;
    
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scale.primaryScale.subtleBackground,
        border: Border.all(color: scale.primaryScale.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SliderTile(
        disabled: false, // Assuming that disabled state is controlled externally
        selected: false, // Manage selection state if needed
        tileScale: ScaleKind.primary, // Adjust based on your theme settings
        title: user.name,
        subtitle: "Pubkey: ${user.pubkey}",
        icon: Icons.person,
        onTap:() async {
            if (!kIsWeb) { if (Platform.isIOS || Platform.isAndroid) { await GoRouterHelper(context).push('/graph'); } } else { 
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text("Selected User: ${user.name} (${user.pubkey}). Viewing Other User Profiles is WIP"),
                ),
              );
            }; 
          },
        endActions: [
          SliderTileAction(
            icon: Icons.delete,
            label: 'Delete',
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

class SearchableMapLocationListWidget extends StatefulWidget {
  final List<MapLocation> locations;

  const SearchableMapLocationListWidget({Key? key, required this.locations}) : super(key: key);

  @override
  _SearchableMapLocationListWidgetState createState() => _SearchableMapLocationListWidgetState();
}

class _SearchableMapLocationListWidgetState extends State<SearchableMapLocationListWidget> {
  TextEditingController _searchController = TextEditingController();
  List<MapLocation> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _filteredLocations = widget.locations; // Start with all locations
  }

  void _filterLocations(String enteredKeyword) {
    List<MapLocation> results = [];
    if (enteredKeyword.isEmpty) {
      results = widget.locations;
    } else {
      results = widget.locations.where((location) =>
          location.name.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
          location.coordinates.toLowerCase().contains(enteredKeyword.toLowerCase())
      ).toList();
    }
    setState(() {
      _filteredLocations = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return styledTitleContainer(
      context: context,
      title: "Searchable Map Locations",
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
              onChanged: _filterLocations,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLocations.length,
              itemBuilder: (context, index) {
                return MapLocationItemWidget(location: _filteredLocations[index]).paddingLTRB(0, 4, 0, 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchableUserListWidget extends StatefulWidget {
  final List<User> users;

  const SearchableUserListWidget({Key? key, required this.users}) : super(key: key);

  @override
  _SearchableUserListWidgetState createState() => _SearchableUserListWidgetState();
}

class _SearchableUserListWidgetState extends State<SearchableUserListWidget> {
  TextEditingController _searchController = TextEditingController();
  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = widget.users; // Start with all users
  }

  void _filterUsers(String enteredKeyword) {
    List<User> results = [];
    if (enteredKeyword.isEmpty) {
      results = widget.users;
    } else {
      results = widget.users.where((user) =>
          user.name.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
          user.pubkey.toLowerCase().contains(enteredKeyword.toLowerCase())
      ).toList();
    }
    setState(() {
      _filteredUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return styledTitleContainer(
      context: context,
      title: "Searchable Users",
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
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                return UserItemWidget(user: _filteredUsers[index]).paddingLTRB(0, 4, 0, 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}