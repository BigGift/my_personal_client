import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test0001/screens/pages/photos_page.dart';

import '../tabs/diary_tab.dart';
import '../tabs/music_tab.dart';
import '../tabs/photo_tab.dart';
import 'MusicDebugPage.dart';
import 'excel_health_page.dart';
import 'music_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  int _counter = 0;
  late TabController _tabController;

  final List<Map<String,String>> _musicList = [
    {'title': '晴天', 'singer': '周杰伦', 'cover': 'https://picsum.photos/id/1/200'},
    {'title': '七里香', 'singer': '周杰伦', 'cover': 'https://picsum.photos/id/2/200'},
    {'title': '稻香', 'singer': '周杰伦', 'cover': 'https://picsum.photos/id/3/200'},
  ];

  final List<String> _photoList = [
    // 替换为 picsum 标准格式（无 ID，稳定不失效）
    'https://picsum.photos/400/400',
    'https://picsum.photos/400/500', // 故意不同高，测试网格适配
    'https://picsum.photos/400/300',
    'https://picsum.photos/id/3/200',
    'https://picsum.photos/id/1/200',
    'https://picsum.photos/id/1/200',
    // 替换为 unsplash 随机图（丰富图片内容）
    'https://source.unsplash.com/random/400x400?nature', // 限定自然风景
    'https://source.unsplash.com/random/400x500?city',  // 限定城市
    'https://source.unsplash.com/random/400x300?animal',// 限定动物
  ];

  final List<Map<String, String>> _diaryList = [
    {
      'title': '旅行日记：大理之行',
      'content': '今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n今天来到了大理，苍山洱海的美景让人沉醉...\n',
      'date': '2025-10-01'
    },
    {
      'title': '学习Flutter的第30天',
      'content': '终于掌握了TabBar和ListView的结合使用...',
      'date': '2025-09-15'
    },
    {
      'title': '学习Flutter的第29天',
      'content': '终于掌握了TabBar和ListView的结合使用...',
      'date': '2025-09-15'
    },
    {
      'title': '学习Flutter的第28天',
      'content': '终于掌握了TabBar和ListView的结合使用...',
      'date': '2025-09-15'
    },
    {
      'title': '学习Flutter的第14天',
      'content': '终于掌握了TabBar和ListView的结合使用...',
      'date': '2025-09-15'
    },
    {
      'title': '学习Flutter的第1天',
      'content': '终于掌握了TabBar和ListView的结合使用...',
      'date': '2025-09-15'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white,Colors.blue],
                    begin:Alignment.topLeft,
                    end:Alignment.bottomRight
                )
            ),
          ),
        ),
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text(widget.title),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //photo of head
            const CircleAvatar(
              radius: 40,
              backgroundImage:NetworkImage("https://gips2.baidu.com/it/u=195724436,3554684702&fm=3028&app=3028&f=JPEG&fmt=auto?w=1280&h=960"),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 12),
            //nick name
            const Text(
              '张大米',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            const SizedBox(height:4),
            //personal text
            Text('love life, recording beautiful! ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 16,)
          ],
        ),
        toolbarHeight: 200,
      ),

      //tab navigation
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              TabBar(
                  controller: _tabController,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: const Color(0xFF6B7280),
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  tabs: const[
                    Tab(text: 'music',),
                    Tab(text: 'photo',),
                    Tab(text: 'record',),
                  ]),

              //Tab content
              Expanded(
                  child: TabBarView(
                      controller: _tabController,
                      children: [
                        MusicTab(),
                        PhotoTab(photoList: _photoList),
                        DiaryTab(diaryList: _diaryList),
                      ])
              )
            ],
          )
      ),

      //botton function view
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhotosPage()),
                );
              },
              icon: const Icon(Icons.photo,color: Color(0xFF6B7280)),
            ),
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExcelHealthPage()),
                );
              },
              icon: const Icon(Icons.music_note,color: Color(0xFF6B7280)),
            ),
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MusicDebugPage()),
                );
              },
              icon: const Icon(Icons.settings,color: Color(0xFF6B7280)),
            )
          ],
        ),
      ),


    );
  }
}