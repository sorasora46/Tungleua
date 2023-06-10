import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tungleua/pages/create_store.dart';
import 'package:tungleua/pages/edit_profile.dart';
import 'package:tungleua/services/user_service.dart';
import 'package:tungleua/widgets/profile_pic.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
        future: UserService().getUserById(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final user = snapshot.data;
            return LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 30),

                              // Profile Image
                              SizedBox(
                                width: 162.77,
                                height: 162.77,
                                child: ProfilePic(image: user?.image),
                              ),
                              const SizedBox(height: 30),

                              // Name
                              Text(
                                user!.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 5),

                              // Email
                              Text(
                                user.email,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),

                              // Divider
                              const SizedBox(height: 15),
                              const Divider(
                                indent: 20,
                                endIndent: 20,
                                thickness: 1,
                              ),

                              // Profile (Go to edit profile, I guess?)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfile(
                                                uid: user.id,
                                                profileImage: user.image,
                                                email: user.email,
                                                name: user.name,
                                              ))).then((_) => setState(() {}));
                                },
                                child: const ListTile(
                                  iconColor: Colors.black,
                                  trailing: Icon(Icons.arrow_right),
                                  leading: Icon(Icons.person_outlined),
                                  title: Text('Profile'),
                                ),
                              ),

                              // Create store
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateStore()));
                                },
                                child: const ListTile(
                                  iconColor: Colors.black,
                                  trailing: Icon(Icons.arrow_right),
                                  leading: Icon(Icons.location_on_outlined),
                                  title: Text('Create Store'),
                                ),
                              ),

                              // Divider
                              const Divider(
                                indent: 20,
                                endIndent: 20,
                                thickness: 1,
                              ),

                              const Spacer(),

                              // Logout Button
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                height: 45,
                                child: FilledButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                  },
                                  style: const ButtonStyle(
                                    // TODO: Use color from theme
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.green),
                                  ),
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )),
    );
  }
}
