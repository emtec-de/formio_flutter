import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FormIO.Flutter'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              'custom_form',
            ),
            child: Container(
              width: 50,
              height: 30,
              color: Colors.black38,
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 4.0),
        children: [
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'demonstration',
                  arguments: 'textfield'),
              child: Text('Textfield')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'demonstration',
                  arguments: 'multiTextfields'),
              child: Text('Multi Textfields')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'demonstration',
                  arguments: 'buttons'),
              child: Text('Buttons')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'demonstration',
                  arguments: 'datetime'),
              child: Text('Dates/Times')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'demonstration',
                  arguments: 'select'),
              child: Text('Select')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'demonstration',
                  arguments: 'checkbox'),
              child: Text('checkbox')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'demonstration',
                  arguments: 'file'),
              child: Text('File')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'demonstration',
                  arguments: 'signature'),
              child: Text('Signature')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'pagination'),
              child: Text('Pagination')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'demonstration',
                  arguments: 'noPagination'),
              child: Text('NoPagination')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'demonstration',
                  arguments: 'validatorSignature'),
              child: Text('Validator Signature')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'demonstration',
                  arguments: 'validatorFields'),
              child: Text('Validator Fields')),
        ],
      ),
    );
  }
}
