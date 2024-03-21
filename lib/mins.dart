import 'package:flutter/material.dart';

    // ignore: must_be_immutable
    class MyMin extends StatelessWidget{
      int min;

      MyMin({super.key, required this.min});

      @override
      Widget build(BuildContext context){
        return Center(
          child: Text(
          min.toString(),
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        );
      }

}
