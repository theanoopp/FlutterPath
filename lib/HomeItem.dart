import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'models/Response.dart';

class HomeItem extends StatefulWidget {
  final Response data;

  const HomeItem({Key key, this.data}) : super(key: key);

  @override
  _HomeItemState createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> {
  CarouselController _carouselController = CarouselController();
  AutoScrollController _titleController;

  int selectedItem = 0;
  var selectedColor = Colors.white;
  var nonSelectedColor = Color.fromRGBO(155, 185, 222, 1);

  @override
  void initState() {
    super.initState();
    _titleController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget.data.title}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${widget.data.subPaths.length} Sub Paths",
                      style: TextStyle(color: Color.fromRGBO(168, 168, 168, 1)),
                    ),
                  ],
                ),
                RaisedButton(
                  child: Text(
                    "Open Path",
                    style: TextStyle(color: nonSelectedColor),
                  ),
                  onPressed: () {},
                  color: Colors.black,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              enableInfiniteScroll: false,
              onPageChanged: (index, data) {
                if (data == CarouselPageChangedReason.manual) {
                  _titleController.scrollToIndex(index,
                      preferPosition: AutoScrollPosition.middle);
                  setState(() {
                    selectedItem = index;
                  });
                }
              },
              reverse: false,
              viewportFraction: 1,
            ),
            items: widget.data.subPaths.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return CachedNetworkImage(
                    imageUrl: i.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.orangeAccent)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fadeOutDuration: Duration(seconds: 1),
                    fadeInDuration: Duration(seconds: 1),
                  );
                },
              );
            }).toList(),
          ),
          Container(
            height: 60,
            decoration: new BoxDecoration(color: Colors.black, boxShadow: [
              new BoxShadow(
                color: Colors.black,
                blurRadius: 20.0,
              ),
            ]),
            child: ListView.builder(
              controller: _titleController,
              itemCount: widget.data.subPaths.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return AutoScrollTag(
                  index: index,
                  controller: _titleController,
                  key: ValueKey(index),
                  child: GestureDetector(
                    onTap: () {
                      _carouselController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 500),
                      );
                      _titleController.scrollToIndex(index,
                          preferPosition: AutoScrollPosition.middle);
                      setState(() {
                        selectedItem = index;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            widget.data.subPaths[index].title,
                            style: TextStyle(
                                fontSize: 18,
                                color: selectedItem == index
                                    ? selectedColor
                                    : nonSelectedColor),
                          ),
                        ),
                        index == widget.data.subPaths.length - 1
                            ? Text("")
                            : Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
