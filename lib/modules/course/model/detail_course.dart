class DetailCourse {
  DetailCourse({
    required this.status,
    required this.message,
    required this.data,
  });

  final num? status;
  final String? message;
  final DetailCourseData? data;

  factory DetailCourse.fromJson(Map<String, dynamic> json){
    return DetailCourse(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : DetailCourseData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  String toString(){
    return "$status, $message, $data, ";
  }
}

class DetailCourseData {
  DetailCourseData({
    required this.code,
    required this.message,
    required this.data,
    required this.error,
  });

  final num? code;
  final String? message;
  final DataData? data;
  final dynamic error;

  factory DetailCourseData.fromJson(Map<String, dynamic> json){
    return DetailCourseData(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : DataData.fromJson(json["data"]),
      error: json["error"],
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
    "error": error,
  };

  @override
  String toString(){
    return "$code, $message, $data, $error, ";
  }
}

class DataData {
  DataData({
    required this.courseId,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.isPaid,
    required this.accessLevel,
    required this.progress,
    required this.sections,
  });

  final String? courseId;
  final String? title;
  final String? description;
  final String? price;
  final String? currency;
  final bool? isPaid;
  final String? accessLevel;
  final num? progress;
  final List<Section> sections;

  factory DataData.fromJson(Map<String, dynamic> json){
    return DataData(
      courseId: json["courseId"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      currency: json["currency"],
      isPaid: json["isPaid"],
      accessLevel: json["accessLevel"],
      progress: json["progress"],
      sections: json["sections"] == null ? [] : List<Section>.from(json["sections"]!.map((x) => Section.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "courseId": courseId,
    "title": title,
    "description": description,
    "price": price,
    "currency": currency,
    "isPaid": isPaid,
    "accessLevel": accessLevel,
    "progress": progress,
    "sections": sections.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$courseId, $title, $description, $price, $currency, $isPaid, $accessLevel, $progress, $sections, ";
  }
}

class Section {
  Section({
    required this.sectionId,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.contents,
  });

  final String? sectionId;
  final String? title;
  final String? description;
  final num? orderIndex;
  final List<Content> contents;

  factory Section.fromJson(Map<String, dynamic> json){
    return Section(
      sectionId: json["sectionId"],
      title: json["title"],
      description: json["description"],
      orderIndex: json["orderIndex"],
      contents: json["contents"] == null ? [] : List<Content>.from(json["contents"]!.map((x) => Content.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "sectionId": sectionId,
    "title": title,
    "description": description,
    "orderIndex": orderIndex,
    "contents": contents.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$sectionId, $title, $description, $orderIndex, $contents, ";
  }
}

class Content {
  Content({
    required this.contentId,
    required this.title,
    required this.description,
    required this.isPreview,
    required this.files,
  });

  final String? contentId;
  final String? title;
  final String? description;
  final bool? isPreview;
  final List<FileElement> files;

  factory Content.fromJson(Map<String, dynamic> json){
    return Content(
      contentId: json["contentId"],
      title: json["title"],
      description: json["description"],
      isPreview: json["isPreview"],
      files: json["files"] == null ? [] : List<FileElement>.from(json["files"]!.map((x) => FileElement.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "contentId": contentId,
    "title": title,
    "description": description,
    "isPreview": isPreview,
    "files": files.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$contentId, $title, $description, $isPreview, $files, ";
  }
}

class FileElement {
  FileElement({
    required this.fileId,
    required this.title,
    required this.fileType,
    required this.isPreview,
    required this.url,
  });

  final String? fileId;
  final String? title;
  final String? fileType;
  final bool? isPreview;
  final String? url;

  factory FileElement.fromJson(Map<String, dynamic> json){
    return FileElement(
      fileId: json["fileId"],
      title: json["title"],
      fileType: json["fileType"],
      isPreview: json["isPreview"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() => {
    "fileId": fileId,
    "title": title,
    "fileType": fileType,
    "isPreview": isPreview,
    "url": url,
  };

  @override
  String toString(){
    return "$fileId, $title, $fileType, $isPreview, $url, ";
  }
}
