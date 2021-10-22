import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familicious_app/controllers/post_controller.dart';
import 'package:familicious_app/views/timeline/create_post_view.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeLineView extends StatelessWidget {
  TimeLineView({Key? key}) : super(key: key);

  final PostController _postController = PostController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Familicious App"),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CreatePostView())),
              icon: Icon(
                UniconsLine.plus_square,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>?>>(
            stream: _postController.getAllPosts(),
            builder: (context, snapshot) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        snapshot.data == null) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }

                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data == null) {
                      return const Center(child: Text('No data available'));
                    }
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            FutureBuilder<Map<String, dynamic>?>(
                                future: _postController.getUsersInfo(snapshot
                                    .data!.docs[index]
                                    .data()!["user_uid"]),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.connectionState ==
                                          ConnectionState.waiting &&
                                      userSnapshot.data == null) {
                                    return const Center(
                                        child: LinearProgressIndicator());
                                  }

                                  if (userSnapshot.connectionState ==
                                          ConnectionState.done &&
                                      userSnapshot.data == null) {
                                    return const ListTile();
                                  }
                                  return ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(
                                      userSnapshot.data!["name"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      timeago.format(
                                          snapshot.data!.docs[index]
                                              .data()!['createdAt']
                                              .toDate(),
                                          allowFromNow: true),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),
                                    ),
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        userSnapshot.data!["picture"],
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.more_horiz,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      onPressed: () {},
                                    ),
                                  );
                                }),
                            snapshot.data!.docs[index]
                                    .data()!['description']!
                                    .isEmpty
                                ? const SizedBox.shrink()
                                : Text(
                                    snapshot.data!.docs[index]
                                        .data()!['description']!,
                                    textAlign: TextAlign.left,
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                snapshot.data!.docs[index].data()!["image_url"],
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
                    );
                    ;
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount:
                      snapshot.data == null ? 0 : snapshot.data!.docs.length);
            }));
  }
}
