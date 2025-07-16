import 'package:flutter/material.dart';
import 'package:main_project/widgets/app_bar.dart';
import 'package:main_project/widgets/background_container.dart';
import 'package:main_project/widgets/drawer/drawer_view.dart';
import 'package:main_project/widgets/section_title.dart';

import '../../controller/phone_call.dart';

class HelpScreen extends StatelessWidget {
  HelpScreen({super.key});
  final List<String> images = [
    'assets/logo/ambulance.png',
    'assets/logo/police.png',
    'assets/logo/fireforce.png',
  ];
  final List<String> emergencyNames = [
    'Ambulance',
    'Police',
    'Fire Force',
  ];
  final List<String> emergencyContacts = [
    '102',
    '100',
    '101',
  ];
  final List<String> helpContacts = [
    'Department of Tourism, Government of Kerala',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
    'The Deputy Director, District Office, Department of Tourism',
  ];
  final List<String> helpContactsPlace = [
    'Park View, Thiruvananthapuram, Kerala, India - 695 033',
    'Norka Building, Thycaud, Thiruvananthapuram - 695014',
    'Ashramam, Kollam - 691002',
    'Civil Station, Pathanamthitta - 689645',
    'House Boat Terminal Building, Finishing Point, Thathampally P.O., Alappuzha - 688013',
    'Kavanattinkara, Kumarakom P.O., Kottayam 686563',
    'Kumily, Idukki - 685509',
    'Ernakulam -682011 Tel: +91 484 235 5956',
    'Chempukavu P.O., Thrissur - 680020',
    'Palakkad - 678001',
    'Uphill, Malappuram - 676505',
    'Kalpetta North, Wayanad - 673121',
    'DTPC Building, Taluk Office Compound, Kannur - 670001',
    'Department of Tourism, Kasaragod - 671121',
  ];
  final List<String> helpContactsMobNo = [
    '+91 471 232 4453',
    '+91 474 276 1555',
    '+91 468 232 6409',
    '+91 481 252 4343',
    '+91 477 226 0722',
    '+91 486 922 2620',
    '+91 484 236 0502',
    '+91 487 233 2419',
    '+91 491 252 8996',
    '+91 483 273 3504',
    '+91 495 237 3862',
    '+91 493 620 4441',
    '+91 497 270 2515',
    '+91 499 423 0416',
  ];
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          showDrawer: true,
          actions: [
            IconButton.outlined(
              onPressed: () {},
              icon: Icon(Icons.sos_rounded),
              color: Colors.red,
            )
          ],
        ),
        drawer: CustomDrawer(),
        body: Column(
          children: [
            buildSectionTitle('Emergency'),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 6),
                  itemCount: 3,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () => makePhoneCall(emergencyContacts[index]),
                        child: Card(
                          child: Stack(
                            children: [
                              Container(
                                height: 175,
                                padding: EdgeInsets.only(
                                    top: 20, right: 10, left: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  images[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  height: 35,
                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                    emergencyNames[index],
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                              Positioned(
                                  bottom: 2,
                                  left: 0,
                                  right: 0,
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.call,
                                            color: Colors.green,
                                            size: 15,
                                          ),
                                          SizedBox(width: 5),
                                          Text('Call'),
                                        ],
                                      )))
                            ],
                          ),
                        ),
                      )),
            ),
            SizedBox(height: 20),
            buildSectionTitle('Help'),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ListView.separated(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 30),
                  shrinkWrap: true,
                  itemCount: helpContacts.length,
                  itemBuilder: (context, index) => Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  helpContacts[index],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(helpContactsPlace[index],
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          Flexible(
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.blueAccent),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () =>
                                  makePhoneCall(helpContactsMobNo[index]),
                              label: Text(
                                'Call',
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
