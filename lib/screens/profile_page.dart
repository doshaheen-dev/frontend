import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

// import '../utils/video_player_utils.dart';
import '../constants/video_player_constants.dart';
import '../widgets/service_item.dart';
import '../widgets/wavy_header.dart';
import '../models/service.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/profile-page";

  final List<Service> availableServices;

  ProfilePage(this.availableServices);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget buildSectionTitle(BuildContext ctx, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(ctx).textTheme.title,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: 600,
      width: 100,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                AppBarTitle("Profile"),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer.network(
                    VideoPlayerConstants.forBiggerBlazesUrl,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Services",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            delegate: SliverChildListDelegate(
              widget.availableServices
                  .map(
                    (serviceData) => ServiceItem(
                      serviceData.title,
                      serviceData.imageUrl,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],

        // const SizedBox(height: 8),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Text(
        //     "Services",
        //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        //   ),
        // ),
        // const SizedBox(height: 8),
      ),
    );
  }
}
