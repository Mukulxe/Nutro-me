import 'package:nutrome_user/screens/dashboards/home_screen.dart';
import 'package:nutrome_user/utility/locator.dart';
import 'package:nutrome_user/utility/DatabaseManager.dart';
import 'package:nutrome_user/utility/shared_pref.dart';
import 'package:nutrome_user/widgets/buttons.dart';
import 'package:nutrome_user/widgets/progress_dailog.dart';
import 'package:nutrome_user/widgets/snackbar_toast.dart';
import 'package:flutter/material.dart';

class EditAddress extends StatefulWidget {
  final bool firstTime;
  const EditAddress({Key? key, required this.firstTime}) : super(key: key);

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController houseNoController = TextEditingController();
  bool buttonTapped = false;
  List<String> address = ["", "", "", ""];

  void getCurrentLocation() async {
    MyDialog().show(context);
    try {
      address = await Locator().fetchAddress();
      setState(() {
        postalCodeController.text = address[2];
        cityController.text = address[0];
        streetController.text = address[1];
      });
      CustomToast().showToast(context, "Located!", false);
    } on Exception catch (_) {
      CustomToast().showToast(context, "Failed To Get location", true);
    } catch (error) {
      CustomToast().showToast(context, "Turn On Location", true);
    }
    Navigator.pop(context);
  }

  void updateLocationToFirebase() {
    unfocus();
    setState(() {
      buttonTapped = true;
    });
    if (postalCodeController.text.isEmpty) {
      return;
    } else if (houseNoController.text.isEmpty) {
      return;
    } else if (streetController.text.isEmpty) {
      return;
    } else if (cityController.text.isEmpty) {
      return;
    }
    UserDB().addUserLocation(postalCodeController.text, streetController.text,
        cityController.text, houseNoController.text, context, widget.firstTime);
    if (widget.firstTime) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }
  }

  void fetchAddress() async {
    try {
      postalCodeController.text = UserSharedPreferences.getPostalCode();
      houseNoController.text = UserSharedPreferences.getHouseNo();
      streetController.text = UserSharedPreferences.getStreet();
      cityController.text = UserSharedPreferences.getCity();
    } on Exception catch (_) {
      postalCodeController.text = '';
      houseNoController.text = '';
      streetController.text = '';
      cityController.text = '';
    } catch (error) {
      postalCodeController.text = '';
      houseNoController.text = '';
      streetController.text = '';
      cityController.text = '';
    }
  }

  unfocus() {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void initState() {
    setState(() {
      fetchAddress();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Edit Address",
          style: TextStyle(
              fontSize: 22, color: Theme.of(context).colorScheme.onTertiary),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EditAddressRow(
                  buttonTapped: buttonTapped,
                  title: "House No.",
                  editingController: houseNoController,
                  placeholder: " A17XX"),
              EditAddressRow(
                  buttonTapped: buttonTapped,
                  title: "Street",
                  editingController: streetController,
                  placeholder: " near gate no. X"),
              EditAddressRow(
                  buttonTapped: buttonTapped,
                  title: "City",
                  editingController: cityController,
                  placeholder: " Faridabad"),
              EditAddressRow(
                  buttonTapped: buttonTapped,
                  title: "Postal Code",
                  editingController: postalCodeController,
                  placeholder: " 1210XX"),
              SizedBox(
                height: 30,
              ),
              Button("Update Location", () {
                updateLocationToFirebase();
              }),
              SizedBox(
                height: 20,
              ),
              Button("Get Current Location", () {
                setState(() {
                  getCurrentLocation();
                });
              }),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditAddressRow extends StatefulWidget {
  final String title;
  final String placeholder;
  final TextEditingController editingController;
  final bool buttonTapped;
  const EditAddressRow(
      {Key? key,
      required this.buttonTapped,
      required this.title,
      required this.editingController,
      required this.placeholder})
      : super(key: key);

  @override
  State<EditAddressRow> createState() => _EditAddressRowState();
}

class _EditAddressRowState extends State<EditAddressRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: widget.editingController,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 88, 88, 88)),
          decoration: InputDecoration(
            errorText: widget.buttonTapped
                ? widget.editingController.text.isEmpty
                    ? "Can't be empty"
                    : null
                : null,
            hintText: widget.placeholder,
            border: InputBorder.none,
            hintStyle: TextStyle(fontWeight: FontWeight.w300),
            suffixIcon: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
          ),
        ),
        Container(
          height: 1.5,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
