import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class TimeLineView extends StatelessWidget {
  const TimeLineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Familicious App"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              UniconsLine.plus_square,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            elevation: 0,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      "Brandison Smith",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "a minute to go",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        "https://images.pexels.com/photos/6798873/pexels-photo-6798873.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Text("some test"),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "https://images.pexels.com/photos/5588321/pexels-photo-5588321.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(UniconsLine.thumbs_up),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(UniconsLine.comment_lines),
                          ),
                        ],
                      ),
                      Row(
                        children: [Icon(UniconsLine.telegram_alt)],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
