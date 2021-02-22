import 'package:Machranga/models/user_deatil_model.dart';
import 'package:Machranga/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    List<FAQ> faqs = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: MyAppBar(
        title: 'FQAs',
      ),
      body: faqs == null
          ? Center(child: Text('NO FAQs '))
          : Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (ctx, i) => FAQCard(faqs[i]),
              ),
            ),
    );
  }
}

class FAQCard extends StatefulWidget {
  final FAQ faq;
  FAQCard(this.faq);

  @override
  _FAQCardState createState() => _FAQCardState(faq);
}

class _FAQCardState extends State<FAQCard> {
  final FAQ faq;
  _FAQCardState(this.faq);

  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    print('${faq.fqaAnswer}');
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(faq.faqQuestion),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: 200,
              child: Text(faq.fqaAnswer),
            )
        ],
      ),
    );
  }
}
