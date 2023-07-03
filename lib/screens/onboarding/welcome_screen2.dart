import 'package:nutrome_user/screens/onboarding/share_location.dart';
import 'package:nutrome_user/screens/onboarding/welcome_screen3.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Boarding2 extends StatefulWidget {
  const Boarding2({Key? key}) : super(key: key);

  @override
  State<Boarding2> createState() => _Boarding2State();
}

class _Boarding2State extends State<Boarding2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2AAF90),
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShareLocation()));
                },
                child: Text("Skip", style: TextStyle(color: Colors.white))),
            SizedBox(
              width: 10,
            ),
          ],
          elevation: 0,
        ),
        body: Container(
          color: Color(0xFF2AAF90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Image.asset(
                        'assets/phone.png',
                        fit: BoxFit.scaleDown,
                      )),
                ],
              ),
              Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                    )),
                    elevation: 50,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Easy",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF40664A),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Boarding3()));
                                  },
                                  child: CircularStepProgressIndicator(
                                    child: Icon(
                                      Icons.arrow_forward_sharp,
                                      color: Colors.black,
                                    ),
                                    totalSteps: 3,
                                    currentStep: 2,
                                    stepSize: 1,
                                    selectedColor: Color(0xFF40664A),
                                    unselectedColor: Colors.grey,
                                    padding: 0,
                                    width: 50,
                                    height: 50,
                                    selectedStepSize: 5,
                                    roundedCap: (_, __) => true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 2),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Payments",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF40664A),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  "Availablity of convenient payment system",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal)),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
