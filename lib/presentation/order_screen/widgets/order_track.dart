import 'package:flutter/material.dart';
import 'package:order_tracker/order_tracker.dart';
import '../../../core/colors/main_colors.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key, required this.orderStatusIndex});

  final int orderStatusIndex;

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List statusList = [
    Status.order,
    Status.shipped,
    Status.outOfDelivery,
    Status.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    List<TextDto> orderList = [
      // TextDto("Your order has been placed", "Fri, 25th Mar '22 - 10:47pm"),
      // TextDto("Seller ha processed your order", "Sun, 27th Mar '22 - 10:19am"),
      // TextDto("Your item has been picked up by courier partner.",
      //     "Tue, 29th Mar '22 - 5:00pm"),
    ];

    List<TextDto> shippedList = [
      // TextDto("Your order has been shipped", "Tue, 29th Mar '22 - 5:04pm"),
      // TextDto("Your item has been received in the nearest hub to you.", null),
    ];

    List<TextDto> outOfDeliveryList = [
      // TextDto("Your order is out for delivery", "Thu, 31th Mar '22 - 2:27pm"),
    ];

    List<TextDto> deliveredList = [
      // TextDto("Your order has been delivered", "Thu, 31th Mar '22 - 3:58pm"),
    ];
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        // automaticallyImplyLeading: true,
        foregroundColor: kBlackColor,

        title: const Text(
          "Track Order",
          style: TextStyle(
            color: kTextBlackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          // GestureDetector(
          //     onTap: () async {
          //       editNotifier.value = !editNotifier.value;
          //     },
          //     child: ValueListenableBuilder(
          //         valueListenable: editNotifier,
          //         builder: (context, value, child) {
          //           return !value
          //               ? SvgPicture.asset('assets/icons/edit.svg')
          //               : SvgPicture.asset('assets/icons/check.svg');
          //         })),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
       
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: OrderTracker(
                status: statusList[widget.orderStatusIndex],
                activeColor: Colors.black,
                inActiveColor: Colors.grey[300],
                orderTitleAndDateList: orderList,
                shippedTitleAndDateList: shippedList,
                outOfDeliveryTitleAndDateList: outOfDeliveryList,
                deliveredTitleAndDateList: deliveredList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
