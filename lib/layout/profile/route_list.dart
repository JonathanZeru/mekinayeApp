import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mekinaye/layout/profile/general_layout.dart';
import 'package:mekinaye/layout/profile/profile_layout.dart';
import 'package:mekinaye/widget/profile/profile_section_container.dart';

class RouteList extends StatelessWidget {
  const RouteList({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper function to create sections
    Widget buildSection(Widget child) {
      return ProfileSectionContainer(
        child: Column(
          children: [child],
        ),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        buildSection(const ProfileLayout()),
        buildSection(const GeneralLayout()),
        // buildSection(const OtherLayout()),
      ],
    );
  }
}
