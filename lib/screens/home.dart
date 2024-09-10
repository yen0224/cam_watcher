import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            // 上半部的三個方塊區域
            _buildTopSection(),
            // 下半部的卡片區域
            Expanded(
              child: _buildCardList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSquareTile('10'),
          _buildSquareTile('20'),
          _buildSquareTile('30'),
        ],
      ),
    );
  }

  Widget _buildSquareTile(String number) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        number,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCardList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: 10, // 示例：顯示10張卡片
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _showDetailModal(context, index);
          },
          child: _buildCard(index),
        );
      },
    );
  }

  Widget _buildCard(int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey4,
              image: DecorationImage(
                image: NetworkImage('https://via.placeholder.com/100'), // 示例圖片
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('事件編號: $index'),
                  Text('事件等級: 中'),
                  Text('簡述: 這是一個事件的簡述。'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailModal(BuildContext context, int index) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoPopupSurface(
          isSurfacePainted: true,
          child: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.85, // 接近滿版高度
            color: CupertinoColors.systemBackground,
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://via.placeholder.com/400'), // 放大顯示圖片
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '事件編號: $index',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('事件等級: 中'),
                      SizedBox(height: 10),
                      Text('詳述: 這裡是事件的詳細描述。詳細信息可以顯示在這裡，給用戶更好的體驗。'),
                      Spacer(),
                      CupertinoButton(
                        child: Text('關閉'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
