import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:nutrome_user/screens/auth/login.dart';
import 'package:nutrome_user/screens/mainpages/edit_address.dart';
import 'package:nutrome_user/screens/mainpages/editprofile.dart';
import 'package:nutrome_user/screens/mainpages/payments_list.dart';
import 'package:nutrome_user/screens/subscription_and_payments/subscription_options.dart';
import 'package:nutrome_user/utility/shared_pref.dart';
import 'package:nutrome_user/widgets/progress_dailog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({
    Key? key,
  }) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String userName = "";
  String userPhone = "";
  String userAddress = "";

  void fetchUserDetails() {
    try {
      userName = UserSharedPreferences.getUserName();
      userPhone = UserSharedPreferences.getUserPhone();
      userAddress =
          "${UserSharedPreferences.getHouseNo()},${UserSharedPreferences.getStreet()},${UserSharedPreferences.getPostalCode()},${UserSharedPreferences.getCity()}";
    } on Exception catch (_) {
    } catch (e) {}
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    fetchUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Account",
          style: TextStyle(
              fontSize: 22, color: Theme.of(context).colorScheme.onTertiary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                        firstTime: false,
                                      ))).then((value) => fetchUserDetails());
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userPhone,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.edit,
                                    size: 18,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditProfile(
                                                  firstTime: false,
                                                ))).then(
                                        (value) => fetchUserDetails());
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    userAddress,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ProfilePicture(
                      name: UserSharedPreferences.getUserName(),
                      radius: 31,
                      fontsize: 21,
                      random: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AccountViewList(
                title: "Edit Address",
                childText: "Edit & Add New Address",
                f: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAddress(
                                firstTime: false,
                              ))).then((value) => fetchUserDetails());
                },
              ),
              AccountViewList(
                title: "Payments",
                childText: "Payments & Details",
                f: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaymentsList()));
                },
              ),
              AccountViewList(
                  title: "Subscription",
                  childText: "Current Subscription",
                  f: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscriptionOptions()));
                  }),
              AccountViewList(
                title: "Contact Us",
                childText: "We would love to hear from you!",
                f: () {
                  launchUrl(Uri.parse("mailto:yournutro.me@gmail.com"));
                },
              ),
              AccountViewList(
                title: "Help & Support",
                childText: "Facing any issue, reach us!",
                f: () {
                  launchUrl(Uri.parse("https://forms.gle/vrUr6PDo8LtREMcKA"),
                      mode: LaunchMode.externalApplication);
                },
              ),
              AccountViewList(
                title: "Account",
                childText: "Logout",
                f: () async {
                  MyDialog().show(context);
                  await FirebaseAuth.instance.signOut();
                  UserSharedPreferences.removeAll();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false);
                },
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountViewList extends StatefulWidget {
  final String title;
  final String childText;
  final Function f;
  const AccountViewList(
      {Key? key, required this.title, required this.childText, required this.f})
      : super(key: key);

  @override
  State<AccountViewList> createState() => _AccountViewListState();
}

class _AccountViewListState extends State<AccountViewList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.f(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    widget.childText,
                    maxLines: 3,
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
