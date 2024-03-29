import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekRatingWidget extends StatelessWidget {
  final Map<String, int> ratings = {
    '2024-03-25': 1,
    '2024-03-26': 3,
    '2024-03-27': 2,
    '2024-03-28': 4,
    '2024-03-29': 5,
    '2024-03-30': 2,
    '2024-03-31': 1,
    // Add more ratings as needed
  };

  final double _dotSize = 15;
  final double _fontSize = 20;
  final double _numberColumnWidth = 25;
  final double _spacingBetweenDotsAndNumbers = 1;
  final Color _dotColor = Colors.lightBlueAccent;
  final Color _textColor = Colors.white;
  final double _containerHeight = 275;

  WeekRatingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _containerHeight,
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRatingsColumn(),
            SizedBox(width: _spacingBetweenDotsAndNumbers),
            _buildDotsMatrix(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingsColumn() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: _numberColumnWidth,
        child: Transform.translate(
          offset: Offset(0, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(5, (index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.5), // Set your padding here
                child: _buildRatingNumber(5 - index),
              );
            }),
          ),
        ),
      ),
    );
  }


  Widget _buildRatingNumber(int number) {
    return Text(
      '$number',
      style: TextStyle(color: _textColor, fontSize: _fontSize),
    );
  }

  Widget _buildDotsMatrix() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDaysRow(),
          ...List.generate(5, (rating) => _buildDotsRow(5 - rating)),
        ],
      ),
    );
  }

  Widget _buildDaysRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        String day = DateFormat('EEEE').format(DateTime.now().add(
            Duration(days: index - DateTime.now().weekday + 1)));
        return Text(
          day.substring(0, 3),
          style: TextStyle(color: _textColor),
        );
      }),
    );
  }

  Widget _buildDotsRow(int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        String dateKey = DateFormat('yyyy-MM-dd').format(
            DateTime.now().add(Duration(days: index - DateTime.now().weekday + 1)));
        bool isRated = ratings[dateKey] == rating;
        return Container(
          width: _dotSize,
          height: _dotSize,
          decoration: BoxDecoration(
            color: isRated ? _dotColor : Colors.transparent,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
