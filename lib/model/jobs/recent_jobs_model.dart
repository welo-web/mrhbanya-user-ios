// To parse this JSON data, do
//
//     final recentJobsModel = recentJobsModelFromJson(jsonString);

import 'dart:convert';

import 'my_jobs_model.dart';

RecentJobsModel? recentJobsModelFromJson(String str) =>
    RecentJobsModel.fromJson(json.decode(str));

String recentJobsModelToJson(RecentJobsModel? data) =>
    json.encode(data!.toJson());

class RecentJobsModel {
  RecentJobsModel({
    this.recent10Jobs,
    this.jobsImage,
  });

  List<JobModel?>? recent10Jobs;
  List<JobsImage?>? jobsImage;

  factory RecentJobsModel.fromJson(Map<String, dynamic> json) =>
      RecentJobsModel(
        recent10Jobs: json["recent_10_jobs"] == null
            ? []
            : List<JobModel?>.from(
                json["recent_10_jobs"]!.map((x) => JobModel.fromJson(x))),
        jobsImage: json["jobs_image"] == null
            ? []
            : List<JobsImage?>.from(
                json["jobs_image"]!.map((x) => JobsImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "recent_10_jobs": recent10Jobs == null
            ? []
            : List<dynamic>.from(recent10Jobs!.map((x) => x!.toJson())),
        "jobs_image": jobsImage == null
            ? []
            : List<dynamic>.from(jobsImage!.map((x) => x!.toJson())),
      };
}

class JobsImage {
  JobsImage({
    this.imageId,
    this.path,
    this.imgUrl,
    this.imgAlt,
  });

  int? imageId;
  String? path;
  String? imgUrl;
  dynamic imgAlt;

  factory JobsImage.fromJson(Map<String, dynamic> json) => JobsImage(
        imageId: json["image_id"],
        path: json["path"],
        imgUrl: json["img_url"],
        imgAlt: json["img_alt"],
      );

  Map<String, dynamic> toJson() => {
        "image_id": imageId,
        "path": path,
        "img_url": imgUrl,
        "img_alt": imgAlt,
      };
}
