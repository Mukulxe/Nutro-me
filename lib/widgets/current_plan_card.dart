import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CurrentSubscriptionCard extends StatelessWidget {
  final String? planName;
  final String? planEndTime;
  final int? daysLeft;
  final bool planActive;
  const CurrentSubscriptionCard(
      {Key? key,
      this.planName,
      this.planEndTime,
      this.daysLeft,
      required this.planActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getPercent() {
      double p;
      try {
        p = planName!.toLowerCase().contains("silver")
            ? 1 - daysLeft! / (7 * 24)
            : planName!.toLowerCase().contains("gold")
                ? 1 - daysLeft! / (14 * 24)
                : planName!.toLowerCase().contains("daimond")
                    ? 1 - daysLeft! / (21 * 24)
                    : 0;
      } on Exception catch (_) {
        p = 0;
      } catch (error) {
        p = 0;
      }
      if (p > 0 && p < 1) {
        return p;
      } else {
        return 0;
      }
    }

    return Card(
      color: planActive
          ? Theme.of(context).primaryColor
          : Color.fromARGB(255, 187, 45, 45),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: planActive
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current Subscription",
                              style: TextStyle(
                                  color: HexColor("#c0c0c0"), fontSize: 16)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("$planName",
                              style: TextStyle(
                                  color: HexColor("#c0c0c0"), fontSize: 16)),
                        ],
                      ),
                    ),
                    Expanded(child: Center()),
                    Image.asset(
                      "assets/ellipse.png",
                      width: 50,
                      height: 40,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 40,
                        lineWidth: 5.0,
                        animation: true,
                        backgroundWidth: 5,
                        backgroundColor: Colors.black,
                        animationDuration: 1000,
                        percent: getPercent(),
                        center: CircleAvatar(
                          backgroundColor: HexColor("#24302e"),
                          radius: 35,
                          child: Text(
                            "${(daysLeft! ~/ 24)} days",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        progressColor: Colors.green,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                                "${(daysLeft! ~/ 24)} days ${(daysLeft! % 24).toDouble()} hrs left!",
                                style: TextStyle(
                                    color: HexColor("#c0c0c0"), fontSize: 14)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                                "Plan Ends on ${planEndTime!.substring(0, 10).trim()}",
                                style: TextStyle(
                                    color: HexColor("#c0c0c0"), fontSize: 14)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Container(
                              height: 30,
                              color: HexColor("#c0c0c0"),
                              width: 30,
                              child: Icon(Icons.star_border_outlined),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            )
          : Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  "assets/noPlan.png",
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
    );
  }
}
