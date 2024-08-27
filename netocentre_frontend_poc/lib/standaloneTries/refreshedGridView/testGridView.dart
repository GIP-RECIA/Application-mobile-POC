import 'package:flutter/material.dart';
import 'package:netocentre_frontend_poc/standaloneTries/refreshedGridView/testItem.dart';

void main() => runApp(const GridViewApp());

class GridViewApp extends StatelessWidget {
  const GridViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const RefreshedGridView()
    );
  }
}

class RefreshedGridView extends StatefulWidget {
  const RefreshedGridView({super.key});

  @override
  State<RefreshedGridView> createState() => _RefreshedGridViewState();
}

class _RefreshedGridViewState extends State<RefreshedGridView> {

  List<TestItem> testItems = [
    TestItem("item 1", true),
    TestItem("item 2", true),
    TestItem("item 3", false),
    TestItem("item 4", true),
    TestItem("item 5", false),
  ];

  void _sortItemsAlphabetically(){
    setState(() {
      testItems.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void _setItemIsFav(int index){
    print(testItems[index].isFav);
    setState(() {
      testItems[index].isFav = !testItems[index].isFav;
    });
    print(testItems[index].isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _sortItemsAlphabetically, icon: const Icon(Icons.sort_by_alpha))
        ],
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
          ),
          itemCount: testItems.length,
          itemBuilder: (context, index) {
            final item = testItems[index];
            return Card(
              color: item.isFav ? Colors.yellow : Colors.purpleAccent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.name),
                  ElevatedButton(
                    onPressed: () => _setItemIsFav(index),
                    child: const Text("change is fav")
                  )
                ],
              ),
            );
          }
      ),
    );
  }
  

}