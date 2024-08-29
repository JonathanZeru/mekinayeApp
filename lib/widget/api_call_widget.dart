import 'package:flutter/material.dart';
import 'package:mekinaye/model/api_exceptions.dart';
import 'package:mekinaye/util/api_call_status.dart';
import 'package:mekinaye/widget/error/error_card.dart';

import 'loading.dart';

class ApiCallWidget extends StatelessWidget {
  final Widget child;
  final ApiCallStatus status;
  final ApiException exception;
  final void Function()? retry;

  const ApiCallWidget(
      {super.key,
      required this.child,
      required this.status,
      required this.exception,
      this.retry});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ApiCallStatus.loading || ApiCallStatus.refresh:
        return Center(
            child: SizedBox(
                width: 50, height: 50, child: Loading()));
      case ApiCallStatus.success:
        return child;
      case ApiCallStatus.error:
        return Center(
          child: ErrorCard(
            image: exception.image ?? "",
            title: exception.title ?? "",
            body: exception.message ?? "",
            refresh: retry,
          ),
        );
      case ApiCallStatus.empty:
        return const Center(
          child: Text('No data available'),
        );
      case ApiCallStatus.holding:
      default:
        return Container();
    }
  }
}
