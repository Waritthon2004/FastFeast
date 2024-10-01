import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.only(top: 50, left: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              'https://static.wikia.nocookie.net/leagueoflegends/images/5/53/Riot_Games_logo_icon.png/revision/latest/scale-to-width-down/250?cb=20230217151156&path-prefix=th',
              width: 100,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Main Menu"),
          ),
          ListTile(
            title: const Text("Home"),
            leading: const Icon(Icons.home),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Setting"),
            leading: const Icon(Icons.settings),
            onTap: () {},
          ),
          const Divider(
            indent: 30,
            endIndent: 30,
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          Expanded(child: Container()),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text("Waritton @ 65011212075"),
          )
        ],
      ),
    ));
  }
}
