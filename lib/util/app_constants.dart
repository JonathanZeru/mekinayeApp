import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mekinaye/generated/assets.dart';

class AppConstants {
  static const String exampleAPI = "https://nextjs-production-9a94.up.railway.app/api";
  static const String url = "http://134.209.218.229/api";
  static const String imageUrl = "http://134.209.218.229";
  static const String wsUrl = "";
  static List<Map<String, dynamic>> termsAndConditions = [
    {
      "title": "Acceptance of Terms",
      "description": "By using this app, you agree to be bound by these terms and conditions. If you do not agree, please do not use the app."
    },
    {
      "title": "User Accounts",
      "description": "To access certain features, you may be required to create an account. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account."
    },
    {
      "title": "Prohibited Conduct",
      "description": "You agree not to engage in any activity that could harm the app or other users, including hacking, transmitting viruses, or using the app for illegal purposes."
    },
    {
      "title": "Intellectual Property",
      "description": "All content, trademarks, and data on the app, including but not limited to text, images, logos, and software, are the property of the app or its licensors and are protected by intellectual property laws."
    },
    {
      "title": "User-Generated Content",
      "description": "By submitting content to the app, you grant us a non-exclusive, royalty-free license to use, modify, and distribute your content in connection with the app's operation."
    },
    {
      "title": "Termination of Use",
      "description": "We reserve the right to suspend or terminate your access to the app at any time, without notice, if you violate these terms or engage in conduct that we deem harmful to the app or other users."
    },
    {
      "title": "Limitation of Liability",
      "description": "To the fullest extent permitted by law, we are not liable for any damages arising from your use of the app or for any interruption, suspension, or termination of the app."
    },
    {
      "title": "Governing Law",
      "description": "These terms and conditions are governed by and construed in accordance with the laws of [Your Country/State]. Any disputes arising from these terms will be subject to the exclusive jurisdiction of the courts in [Your Country/State]."
    },
    {
      "title": "Changes to Terms",
      "description": "We may update these terms and conditions from time to time. Continued use of the app following any changes constitutes your acceptance of the new terms."
    },
    {
      "title": "Contact Information",
      "description": "If you have any questions about these terms and conditions, please contact us at [your contact information]. We are here to assist you with any inquiries."
    }
  ];

  static List<Map<String, dynamic>> privacyPolicy = [
    {
      "title": "Collection of Personal Information",
      "description": "We collect personal information that you voluntarily provide to us when registering on the app, such as your name, email address, and contact details."
    },
    {
      "title": "Use of Collected Information",
      "description": "The information we collect is used to enhance your experience on the app, such as personalizing content, providing customer support, and improving our services."
    },
    {
      "title": "Sharing of Information",
      "description": "We do not share your personal information with third parties without your consent, except to comply with legal obligations or to protect our rights."
    },
    {
      "title": "Data Security",
      "description": "We implement security measures to protect your data, including encryption and secure storage, to prevent unauthorized access, disclosure, or alteration."
    },
    {
      "title": "Cookies and Tracking Technologies",
      "description": "Our app uses cookies and similar tracking technologies to improve functionality and analyze usage patterns. You can control cookie preferences through your device settings."
    },
    {
      "title": "User Rights",
      "description": "You have the right to access, correct, or delete your personal information at any time. You can also withdraw your consent for data processing or object to certain processing activities."
    },
    {
      "title": "Data Retention",
      "description": "We retain your personal information only for as long as necessary to fulfill the purposes outlined in this policy, or as required by law."
    },
    {
      "title": "Children's Privacy",
      "description": "Our app is not intended for children under the age of 13. We do not knowingly collect personal information from children without parental consent."
    },
    {
      "title": "Changes to Privacy Policy",
      "description": "We may update this privacy policy from time to time. We will notify you of any significant changes by posting the new policy on the app and updating the effective date."
    },
    {
      "title": "Contact Information",
      "description": "If you have any questions or concerns about this privacy policy, please contact us at [your contact information]. We are here to assist you with any inquiries."
    }
  ];

  static List<Map<String, dynamic>> faqs = [
    {
      "title": "How do I search for a car model in the app?",
      "description": "Use the search bar at the top of the home screen to enter the car model or brand you're looking for. You can also filter results by various criteria like price, year, and mileage."
    },
    {
      "title": "How can I compare different car models?",
      "description": "The app allows you to select multiple car models and compare their features side by side. Just select the models you want to compare and click on the 'Compare' button."
    },
    {
      "title": "How do I save a car to my favorites?",
      "description": "To save a car to your favorites, tap the heart icon on the car listing. You can view your saved cars under the 'Favorites' section in your profile."
    },
    {
      "title": "How can I contact the seller?",
      "description": "You can contact the seller directly through the app by clicking on the 'Contact Seller' button on the car listing. You can choose to call, message, or email the seller."
    },
    {
      "title": "What financing options are available?",
      "description": "The app provides various financing options through partnered financial institutions. You can view these options by selecting the 'Finance' tab on the car listing page."
    },
    {
      "title": "How do I schedule a test drive?",
      "description": "To schedule a test drive, click on the 'Schedule Test Drive' button on the car listing. You'll be prompted to choose a date and time that works for you."
    },
    {
      "title": "Can I trade in my old car?",
      "description": "Yes, the app allows you to trade in your old car. Go to the 'Trade-In' section, enter your car's details, and get an estimated trade-in value that can be applied to your next purchase."
    },
    {
      "title": "How do I get alerts for new listings?",
      "description": "You can set up alerts for new listings by going to the 'Notifications' section in your profile. Set your preferences for the types of cars you're interested in, and you'll receive alerts when new listings match your criteria."
    },
    {
      "title": "What should I do if I encounter a technical issue?",
      "description": "If you experience any technical issues with the app, you can reach out to our support team through the 'Help & Support' section. Provide details about the issue, and our team will assist you promptly."
    },
    {
      "title": "How do I sell my car through the app?",
      "description": "To sell your car, go to the 'Sell Your Car' section, fill in the necessary details, upload photos, and set your price. Your listing will be live once it's reviewed and approved by our team."
    }
  ];

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
