class NewsModel{
  String title;
  String descreption;
  String url;
  String imgurl;
  String name;
NewsModel({this.url,this.name,this.title,this.descreption,this.imgurl});
factory NewsModel.fromMap(Map<String, dynamic> parsedJson) {
return NewsModel(
url: parsedJson["url"],
  descreption: parsedJson["description"],
  imgurl: parsedJson["urlToImage"],
  name:  parsedJson["name"],
title: parsedJson["title"]
);
}
}