import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mekinaye/generated/assets.dart';

class AppConstants {
  static const String exampleAPI = "https://nextjs-production-9a94.up.railway.app/api";
  static const String url = "http://134.209.218.229/api";
  static const String imageUrl = "http://134.209.218.229";
  static const String wsUrl = "";

  static List<Map<String, dynamic>> homeScreenGrid = [
    {"id": 0, "name": "Ethio Spare",
      "icon": CupertinoIcons.car_detailed,
      "image": "assets/images/sparepart.jpg"},
    {"id": 1, "name": "Ethio Garage",
      "icon": CupertinoIcons.settings,
      "image": "assets/images/workshopjpg.jpg"
      },
    {"id": 2, "name": "Traffic Police",
      "icon": Icons.local_gas_station,
      "image": "assets/images/trafficjpg.jpg"},
    {"id": 2, "name": "Gas Station",
      "icon": Icons.local_gas_station,
      "image": "assets/images/gasStationjpg.jpg"}
  ];
  static List<Map<String, dynamic>> workShops = [
    {"id": 0, "name": "Toyota", "icon": CupertinoIcons.car_detailed},
    {"id": 1, "name": "Suzuki", "icon": CupertinoIcons.car_detailed},
    {"id": 2, "name": "Lamborghini", "icon": CupertinoIcons.car_detailed},
    {"id": 3, "name": "Ford", "icon": CupertinoIcons.car_detailed},
    {"id": 4, "name": "Honda", "icon": CupertinoIcons.car_detailed},
    {"id": 5, "name": "BMW", "icon": CupertinoIcons.car_detailed},
    {"id": 6, "name": "Mercedes", "icon": CupertinoIcons.car_detailed},
    {"id": 7, "name": "Audi", "icon": CupertinoIcons.car_detailed},
    {"id": 8, "name": "Chevrolet", "icon": CupertinoIcons.car_detailed},
    {"id": 9, "name": "Nissan", "icon": CupertinoIcons.car_detailed},
    {"id": 10, "name": "Hyundai", "icon": CupertinoIcons.car_detailed},
    {"id": 11, "name": "Kia", "icon": CupertinoIcons.car_detailed},
  ];
  static List<Map<String, dynamic>> spareParts = [
    {"id": 0, "name": "Mirrors", "icon": CupertinoIcons.settings},
    {"id": 1, "name": "Brakes", "icon": CupertinoIcons.settings},
    {"id": 2, "name": "Tires", "icon": CupertinoIcons.settings},
    {"id": 3, "name": "Headlights", "icon": CupertinoIcons.settings},
    {"id": 4, "name": "Bumpers", "icon": CupertinoIcons.settings},
    {"id": 5, "name": "Engine", "icon": CupertinoIcons.settings},
    {"id": 6, "name": "Transmission", "icon": CupertinoIcons.settings},
    {"id": 7, "name": "Radiator", "icon": CupertinoIcons.settings},
    {"id": 8, "name": "Exhaust", "icon": CupertinoIcons.settings},
    {"id": 9, "name": "Suspension", "icon": CupertinoIcons.settings},
    {"id": 10, "name": "Steering Wheel", "icon": CupertinoIcons.settings},
    {"id": 11, "name": "Windshield", "icon": CupertinoIcons.settings},
  ];
  static List<Map<String, dynamic>> chats = [
    {
      "name": "John Doe",
      "lastMessage": "I'm interested in buying the Toyota Corolla. Can we negotiate the price?",
      "description": "Obey posted speed limits and adjust speed according to road conditions.",
      "date": "2024-08-13"
    },
    {
      "name": "Jane Smith",
      "lastMessage": "The car is still available. When would you like to inspect it?",
      "description": "Always wear a seat belt while driving or riding in a vehicle.",
      "date": "2024-08-12"
    },
    {
      "name": "Michael Johnson",
      "lastMessage": "I'm looking to sell my Honda Civic. Are you interested?",
      "description": "Come to a complete stop at stop signs and proceed only when it is safe.",
      "date": "2024-08-11"
    },
    {
      "name": "Emily Davis",
      "lastMessage": "Can we schedule a test drive for the BMW this weekend?",
      "description": "Obey all traffic lights and signals, and stop on red.",
      "date": "2024-08-10"
    },
    {
      "name": "David Martinez",
      "lastMessage": "I noticed some scratches on the car. Can we discuss a discount?",
      "description": "Never drive under the influence of alcohol or drugs.",
      "date": "2024-08-09"
    },
    {
      "name": "Sarah Lee",
      "lastMessage": "The paperwork for the Audi is ready. Let's finalize the sale tomorrow.",
      "description": "Yield to pedestrians at crosswalks and intersections.",
      "date": "2024-08-08"
    },
    {
      "name": "James Wilson",
      "lastMessage": "I'm interested in your Ford Mustang. Can I get more details?",
      "description": "Avoid using mobile phones or any electronic devices while driving.",
      "date": "2024-08-07"
    },
    {
      "name": "Olivia Brown",
      "lastMessage": "The offer for the Mercedes is accepted. When can you pick it up?",
      "description": "Do not overtake vehicles in no-passing zones or when it is unsafe.",
      "date": "2024-08-06"
    },
    {
      "name": "William Taylor",
      "lastMessage": "I'm considering your Chevrolet for purchase. Can we meet today?",
      "description": "Always use indicators when turning or changing lanes.",
      "date": "2024-08-05"
    },
    {
      "name": "Sophia Harris",
      "lastMessage": "The deal on the Hyundai is good to go. Let's proceed with the payment.",
      "description": "Maintain a safe distance from the vehicle in front to avoid collisions.",
      "date": "2024-08-04"
    }
  ];

  static List<Map<String, dynamic>> trafficRules = [
    {
      "name": "Speed Limit",
      "description": "Obey posted speed limits and adjust speed according to road conditions. Obey posted speed limits and adjust speed according to road conditions.Obey posted speed limits and adjust speed according to road conditions.Obey posted speed limits and adjust speed according to road conditions.Obey posted speed limits and adjust speed according to road conditions.Obey posted speed limits and adjust speed according to road conditions.Obey posted speed limits and adjust speed according to road conditions."
    },
    {
      "name": "Seat Belt Use",
      "description": "Always wear a seat belt while driving or riding in a vehicle."
    },
    {
      "name": "Stop Signs",
      "description": "Come to a complete stop at stop signs and proceed only when it is safe."
    },
    {
      "name": "Traffic Signals",
      "description": "Obey all traffic lights and signals, and stop on red."
    },
    {
      "name": "No Drunk Driving",
      "description": "Never drive under the influence of alcohol or drugs."
    },
    {
      "name": "Pedestrian Right of Way",
      "description": "Yield to pedestrians at crosswalks and intersections."
    },
    {
      "name": "No Mobile Phone Use",
      "description": "Avoid using mobile phones or any electronic devices while driving."
    },
    {
      "name": "No Overtaking",
      "description": "Do not overtake vehicles in no-passing zones or when it is unsafe."
    },
    {
      "name": "Use of Indicators",
      "description": "Always use indicators when turning or changing lanes. Always use indicators when turning or changing lanes.Always use indicators when turning or changing lanes.Always use indicators when turning or changing lanes.Always use indicators when turning or changing lanes.Always use indicators when turning or changing lanes.Always use indicators when turning or changing lanes.Always use indicators when turning or changing lanes."
    },
    {
      "name": "Keep Safe Distance",
      "description": "Maintain a safe distance from the vehicle in front to avoid collisions."
    },
    {
      "name": "Yield to Emergency Vehicles",
      "description": "Move aside and allow emergency vehicles to pass."
    },
    {
      "name": "No U-Turns",
      "description": "Do not make U-turns where prohibited by signs or road markings."
    },
  ];

  static List<Map<String, dynamic>> languages = [
    {"id": 0, "name": "Amahric", "image": Assets.imagesConnectPeople},
    {"id": 1, "name": "Afaan Oromo", "image": Assets.imagesConnectPeople},
    {"id": 2, "name": "Tigrigna", "image": Assets.imagesConnectPeople}
  ];


}
