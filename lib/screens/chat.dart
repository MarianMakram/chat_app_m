import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constans/const.dart';
import '../widgets/chat_bubble.dart';

class Home extends StatelessWidget {
  final CollectionReference message =
  FirebaseFirestore.instance.collection(kMsgCollection);

  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final String emailController =
    ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0xff8BA9E4)),
        ),
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                "assets/Images/sora1.jpg",
                width: 51,
                height: 51,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ListTile(
                title: const Text(
                  "Marian",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                subtitle: const Text(
                  "last seen at 12:33 AM",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_outlined,
                size: 29, color: Colors.white),
          ),
        ],
        toolbarHeight: 88,
      ),
      body: Column(
        children: [
          /// 🔹 StreamBuilder only for messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: message.orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messageList = snapshot.data!.docs
                    .map((doc) => Message.fromjson(doc))
                    .toList();

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    final msg = messageList[index];
                    return msg.id == emailController
                        ? ChatBubble(message: msg)
                        : ChatBubbleTwo(message: msg);
                  },
                );
              },
            ),
          ),

          /// 🔹 Input field outside StreamBuilder to avoid rebuilds
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                onSubmitted: (data) async {
                  if (data.trim().isEmpty) return;

                  await message.add({
                    'message': data.trim(),
                    'createdAt': DateTime.now(),
                    'id': emailController,
                  });

                  controller.clear();

                  _scrollController.animateTo(
                    0.0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                decoration: InputDecoration(
                  hintText: "Send Message",
                  suffixIcon: const Icon(Icons.send),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(33),
                    borderSide: const BorderSide(
                      color: Color(0xff8BA9E4),
                      width: 2.3,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(33),
                    borderSide: const BorderSide(
                      color: Color(0xff8BA9E4),
                      width: 2.3,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(33),
                    borderSide: const BorderSide(
                      color: Color(0xff8BA9E4),
                      width: 2.3,
                    ),
                  ),
                  fillColor: Colors.white70,
                  filled: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
