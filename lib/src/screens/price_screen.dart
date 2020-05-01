import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:lendy/resources/bloc_provider.dart';
import 'package:lendy/src/blocs/ItemBloc.dart';
import 'package:lendy/src/models/item.dart';

class PriceScreen extends StatefulWidget {

  final String titleText;
  final Item item;

  @override
  State<StatefulWidget> createState() {
    return PriceScreenState();
  }

  PriceScreen({Key key, this.titleText, this.item, });
}

class PriceScreenState extends State<PriceScreen> {
  StreamSubscription<bool> subscription;

  ItemBloc bloc;
  var dailyCon = new MoneyMaskedTextController(
    initialValue: 1,
    precision: 0,
    decimalSeparator: '',
  );

  var weeklyCon = new MoneyMaskedTextController(
//    initialValue: 1,
    precision: 0,
    decimalSeparator: '',
  );

  var monthlyCon = new MoneyMaskedTextController(
//    initialValue: 1,
    precision: 0,
    decimalSeparator: '',
  );

  @override
  void initState() {
    super.initState();



    //:TODO Remember to stop listening when disposed
    weeklyCon.addListener(() {
      bloc.changeWeekly(weeklyCon.text);
    });

    monthlyCon.addListener(() {
      bloc.changeMonthly(monthlyCon.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of(context);
//    assert (bloc.photosList.isNotEmpty);

    return Scaffold(
        appBar: AppBar(
          title: Text('Set pricing'),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: dW(bloc),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: wW(bloc),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: mW(bloc),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[depW(bloc), Text('Type 0 if no deposit')],
            ),
          ],
        )),
        floatingActionButton: StreamBuilder(
          stream: bloc.post,
          builder: (context, snapshot) {
            return StreamBuilder(
              stream: bloc.showProgress,
              builder: (context1, snapshot1) {


                if (snapshot1.hasData && snapshot1.data) {
                  return FloatingActionButton.extended(
                    backgroundColor: Colors.grey,
                    onPressed: null,
                    label: widget.titleText==null?Text('Posting...'):Text('Updating...'),
                    icon: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                      ),
                    ),
                  );
                }


                return FloatingActionButton.extended(
                  backgroundColor: !snapshot.hasData || !snapshot.data
                      ? Colors.grey
                      : Colors.blue,
                  onPressed: !snapshot.hasData || !snapshot.data
                      ? null
                      : () {
                          widget.titleText==null?
                          post(context):update(context);
                        },
                  label: widget.titleText==null?Text('Post'):Text('Update'),
                  icon: Icon(Icons.send),
                );
              },
            );
          },
        ),
      );
  }

  void update(con) async {
    subscription = bloc.uploadComplete.listen((data){});

    bloc.updateItem(widget.item.docID, widget.item.imgNames);

    subscription.onData((dat){
      if (dat) {
        bloc.resetAll();
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
      }
    });

  }

  void post(con) async {
    //:TODO close this somewhere, somehow??

    subscription = bloc.uploadComplete.listen((data){});

    bloc.uploadItem();

    subscription.onData((dat){
      if (dat) {
        bloc.resetAll();
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
      }
    });

    // TODO: possible problem using first here ????

  }

  @override
  void dispose() {
//    bloc.dispose();
    super.dispose();

    if(subscription!=null) subscription.cancel();

    //:TODO make sure this works
    print("yoyoyoy");

//    bloc.reset();
//    bloc.dispose();
  }

  Widget dW(ItemBloc bloc) {
    return StreamBuilder(
      stream: bloc.daily,
      builder: (context, snapshot) {
        dailyCon.text = snapshot.data;
        return TextField(
          onChanged: bloc.changeDaily,
//          controller: dailyCon,
          inputFormatters: [
            WhitelistingTextInputFormatter(RegExp('[0-9]')),
            BlacklistingTextInputFormatter(RegExp('^0+')),
            LengthLimitingTextInputFormatter(3)
          ],
          decoration: InputDecoration(
              suffix: Text(
                'DKK',
                style: TextStyle(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
              hintText: 'e.g. 99',
              labelText: 'Daily:',
              errorText: snapshot.error),
          keyboardType: TextInputType.number,
        );
      },
    );
  }

  Widget wW(ItemBloc bloc) {
    return StreamBuilder(
      stream: bloc.weekly,
      builder: (context, snapshot) {
//        weeklyCon.text = snapshot.data;
        if (snapshot.hasData) {
          weeklyCon.value = TextEditingValue(
              text: snapshot.data,
              selection: TextSelection.fromPosition(
                  TextPosition(offset: snapshot.data.toString().length)));
        }
        return TextField(
          controller: weeklyCon,
//          onChanged: bloc.changeWeekly,
          inputFormatters: [
            WhitelistingTextInputFormatter(RegExp('[0-9]')),
            BlacklistingTextInputFormatter(RegExp('^0+')),
            LengthLimitingTextInputFormatter(3)
          ],
          decoration: InputDecoration(
              suffix: Text(
                'DKK',
                style: TextStyle(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
              hintText: 'e.g. 99',
              labelText: 'Weekly:',
              errorText: snapshot.error),
          keyboardType: TextInputType.number,
        );
      },
    );
  }

  Widget mW(ItemBloc bloc) {
    return StreamBuilder(
      stream: bloc.monthly,
      builder: (context, snapshot) {
//        monthlyCon.text = snapshot.data;
        if (snapshot.hasData) {
          monthlyCon.value = TextEditingValue(
              text: snapshot.data,
              selection: TextSelection.fromPosition(
                  TextPosition(offset: snapshot.data.toString().length)));
        }
        return TextField(
          controller: monthlyCon,
//          onChanged: bloc.changeMonthly,
          inputFormatters: [
            WhitelistingTextInputFormatter(RegExp('[0-9]')),
            BlacklistingTextInputFormatter(RegExp('^0+')),
            LengthLimitingTextInputFormatter(3)
          ],
          decoration: InputDecoration(
              suffix: Text(
                'DKK',
                style: TextStyle(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
              hintText: 'e.g. 99',
              labelText: 'Monthly:',
              errorText: snapshot.error),
          keyboardType: TextInputType.number,
        );
      },
    );
  }

  Widget depW(ItemBloc bloc) {
    return StreamBuilder(
      initialData: 0,
      stream: bloc.deposit,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 100.0),
          child: TextField(
//            controller: ,
            onChanged: bloc.changeDeposit,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp('[0-9]')),
              BlacklistingTextInputFormatter(RegExp('^0+(?=[0-9])')),
              LengthLimitingTextInputFormatter(3)
            ],
            decoration: InputDecoration(
                suffix: Text(
                  'DKK',
                  style: TextStyle(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                hintText: 'e.g. 99',
                labelText: 'Deposit:',
                errorText: snapshot.error),
            keyboardType: TextInputType.number,
          ),
        );
      },
    );
  }
}
