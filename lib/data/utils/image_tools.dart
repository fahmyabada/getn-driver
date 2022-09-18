import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:getn_driver/data/utils/constant.dart';

// ignore: camel_case_types
enum kSize { small, medium, large }

class ImageTools {
  static String prestashopImage(String url, [kSize? size = kSize.medium]) {
    if (url.contains('?')) {
      switch (size) {
        case kSize.large:
          return url.replaceFirst('?', '/large_default?');
        case kSize.small:
          return url.replaceFirst('?', '/small_default?');
        default: // kSize.medium
          return url.replaceFirst('?', '/medium_default?');
      }
    }
    switch (size) {
      case kSize.large:
        return '$url/large_default';
      case kSize.small:
        return '$url/small_default';
      default: // kSize.medium
        return '$url/medium_default';
    }
  }

  static NetworkImage networkImage(String? url, [kSize size = kSize.medium]) {
    return NetworkImage(url!);
  }

  /// Smart image function to load image cache and check empty URL to return empty box
  /// Only apply for the product image resize with (small, medium, large)
  static Widget image({
    String? url,
    kSize? size,
    double? width,
    double? height,
    BoxFit? fit,
    String? tag,
    double offset = 0.0,
    bool isResize = false,
    bool? isVideo = false,
    bool hidePlaceHolder = false,
    bool forceWhiteBackground = false,
    String kImageProxy = '',
  }) {
    if (height == null && width == null) {
      width = 200;
    }
    var ratioImage = 1.4;

    if (url?.isEmpty ?? true) {
      return ExtendedImage.network(
        placeHolderImage,
        width: width,
        height: height,
        fit: fit,
        cache: true,
        enableLoadState: true,
        loadStateChanged: (ExtendedImageState state) {
          Widget? widget;
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              // showLoadingDialog();
              break;
            case LoadState.completed:
              widget = ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: width,
                height: height,
                fit: fit,
              );
              break;
            case LoadState.failed:
              widget = Container(
                width: width,
                height: height ?? width! * ratioImage,
                color: const Color(0x0D000000),
              );
              break;
          }
          return widget;
        },
      );
    } else if (url!.contains("assets")) {
      return Image.asset(
        url,
        width: width,
        height: height,
        fit: fit,
      );
    } else if (url.startsWith("http")) {
      return ExtendedImage.network(
        url,
        width: width,
        height: height,
        fit: fit,
        cache: true,
        enableLoadState: true,
        loadStateChanged: (ExtendedImageState state) {
          Widget? widget;
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              // showLoadingDialog();
              break;
            case LoadState.completed:
              widget = ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: width,
                height: height,
                fit: fit,
              );
              break;
            case LoadState.failed:
              widget = Container(
                width: width,
                height: height ?? width! * ratioImage,
                color: const Color(0x0D000000),
              );
              break;
          }
          return widget;
        },
      );
    } else {
      return Image.file(File(url), height: height);
    }
  }

  /// cache avatar for the chat
  static CachedNetworkImage getCachedAvatar(String avatarUrl) {
    return CachedNetworkImage(
      imageUrl: avatarUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  static BoxFit boxFit(String? fit) {
    switch (fit) {
      case 'contain':
        return BoxFit.contain;
      case 'fill':
        return BoxFit.fill;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'scaleDown':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }
}
