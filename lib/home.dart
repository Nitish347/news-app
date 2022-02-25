import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'news_model.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<NewsModel> newsList = new List<NewsModel>();
  bool _loading = false;
  String query;
  List<String> countryList = [
    'Australia',
    'Belgium',
    'Brazil',
    'Canada',
    'China',
    'France',
    'Germany',
    'India',
    'Indonesia',
    'Ireland',
    'Israel',
    'Japan',
    'New Zealand',
    'Russia',
    'Saudi Arabia',
    'Singapore',
    'South Africa',
    'South korea',
    'Switzerland',
    'UAE',
    'United Kingdom',
    'Ukrain',
    'United State'
  ];
  List<String> countryCode = [
    'au',
    'be',
    'br',
    'ca',
    'cn',
    'fr',
    'de',
    'in',
    'id',
    'ie',
    'il',
    'jp',
    'nz',
    'ru',
    'sa',
    'sg',
    'za',
    'kr',
    'ch',
    'ae',
    'ua',
    'gb',
    'us'
  ];
  @override
  void initState() {
    getNews('in');
    super.initState();
  }

  getNews(String query) async {
    setState(() {
      _loading = true;
    });
    newsList = new List();
    String api_url =
        "https://newsapi.org/v2/top-headlines?country=$query&apiKey=2b826ea9d85542a898f1ef683de48b71";
    var response = await http.get(Uri.parse(api_url));

    Map<String, dynamic> jsonData = json.decode(response.body);
    // print(jsonData["totalResults"]);
    jsonData["articles"].forEach((element) {
      if (element["title"] != null &&
          element["url"] != null &&
          element["description"] != null &&
          element["urlToImage"] != null) {
        NewsModel newsModel = new NewsModel();
        newsModel = NewsModel.fromMap(element);
        newsList.add(newsModel);
      } else {}
    });
    // print("nitish");
    print(newsList);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.teal.withOpacity(0.4),
          Colors.teal,
        ])),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 6,
                color: Colors.teal,
                child: Center(
                  child: Text(
                    "Select Country",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
                children: List.generate(countryList.length, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        getNews(countryCode[index]);
                      },
                      child: ListTile(
                        leading: Text(
                          countryList[index],
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        trailing: Icon(
                          CupertinoIcons.search,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      )),
      appBar: AppBar(
        shadowColor: Colors.green,
        backgroundColor: Colors.teal,
        title: Center(
            child: Text(
          "Breaking News",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            _loading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.black,
                  ))
                : Container(
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      // padding: EdgeInsets.all(15),
                      padding: EdgeInsets.only(bottom: 50),
                      children: List.generate(newsList.length, (index) {
                        return GridTile(
                            child: NewsTile(
                          title: newsList[index].title,
                          url: newsList[index].url,
                          imgurl: newsList[index].imgurl,
                          desc: newsList[index].descreption,
                        ));
                      }),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  String title, desc, url, imgurl;
  NewsTile({this.title, this.imgurl, this.url, this.desc});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsPage(
                          newsUrl: url,
                        )));
          },
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Image.network(
                    imgurl,
                    fit: BoxFit.cover,
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Container(
                        color: Colors.teal.withOpacity(0.3),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  desc,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class NewsPage extends StatefulWidget {
  final String newsUrl;
  NewsPage({this.newsUrl});
  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "News",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        // padding: EdgeInsets.only(top: 30),
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.newsUrl,
        ),
      ),
    );
  }
}
