import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nbaapp/model/team.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Team> teams = [];

  // get teams
  Future getTeams() async {
    var response =
        await http.get(Uri.https('api.balldontlie.io', 'v1/teams'), headers: {
      'Authorization': 'cc4989cf-67c9-42cc-9565-bca305db85fb',
    });
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      final team = Team(
        id: eachTeam['id'],
        conference: eachTeam['conference'],
        division: eachTeam['division'],
        city: eachTeam['city'],
        name: eachTeam['name'],
        fullName: eachTeam['full_name'],
        abbreviation: eachTeam['abbreviation'],
      );

      teams.add(team);
    }
  }

  @override
  Widget build(BuildContext context) {
    getTeams();
    return Scaffold(
      body: FutureBuilder(
          future: getTeams(),
          builder: (context, snapshot) {
            // is it done loading? then show team data
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(teams[index].abbreviation),
                      subtitle: Text(teams[index].city),
                    ),
                  );
                },
              );
            }
            // if it's still loading, then show a loading circle
            else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
