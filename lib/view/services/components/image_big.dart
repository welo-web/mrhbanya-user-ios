import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/rtl_service.dart';

class ImageBig extends StatelessWidget {
  const ImageBig(
      {super.key, required this.serviceName, required this.imageLink});
  final serviceName;
  final imageLink;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            height: 295,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: imageLink,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            )),
        Container(
          height: 295,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.7),
                  Colors.black.withOpacity(.1)
                ]),
          ),
        ),
        Consumer<RtlService>(
          builder: (context, rtlP, child) => AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: 19,
                )),
          ),
        )
      ],
    );
  }
}
