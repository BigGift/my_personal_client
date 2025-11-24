import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '大米的主页',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.green),
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.orange
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      //debugShowCheckedModeBanner: false,
    );
  }
}

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
    // 替换为 unsplash 随机图（丰富图片内容）
    'https://source.unsplash.com/random/400x400?nature', // 限定自然风景
    'https://source.unsplash.com/random/400x500?city',  // 限定城市
    'https://source.unsplash.com/random/400x300?animal',// 限定动物
  ];

  final List<Map<String, String>> _diaryList = [
    {
      'title': '旅行日记：大理之行',
      'content': '今天来到了大理，苍山洱海的美景让人沉醉...',
      'date': '2025-10-01'
    },
    {
      'title': '学习Flutter的第30天',
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
                  colors: [Colors.lightGreen,Colors.green],
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
                    //music tab
                    ListView.separated(
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (context,index) => const Divider(height: 1,),
                        itemCount: _musicList.length,
                        itemBuilder: (context,index){
                          final music = _musicList[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                music['cover']!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(music['title']!),
                            subtitle: Text(music['singer']!),
                            trailing: const Icon(Icons.play_arrow,color: Color(0xFF6366F1),),
                            onTap: (){
                              //play music logic //TODO
                            },
                          );

                        },
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: _photoList.map((photo) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              photo,
                              fit: BoxFit.cover,
                              height: 180,
                              width: double.infinity,
                              errorBuilder: (context,error,stackTrace){
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image,color: Colors.grey,size: 40),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1))),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    //recording tab
                    ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _diaryList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final diary = _diaryList[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  diary['title']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  diary['content']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    diary['date']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),


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
                onPressed: (){},
                icon: const Icon(Icons.settings,color: Color(0xFF6B7280)),
            ),
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.settings,color: Color(0xFF6B7280)),
            ),
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.settings,color: Color(0xFF6B7280)),
            )
          ],
        ),
      ),


    );
  }
}
