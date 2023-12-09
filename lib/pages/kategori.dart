import 'package:flutter/material.dart';
import 'package:meals/pages/meal.dart';

import '../services/source.dart';
import '../model/category_model.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<CategoryNew>> futureCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = ApiSource().getCategory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'MEAL CATEGORIES',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [_buildsucces(futureCategory: futureCategory)],
            ),
          ),
        ));
  }
}

class _buildsucces extends StatelessWidget {
  const _buildsucces({
    super.key,
    required this.futureCategory,
  });

  final Future<List<CategoryNew>> futureCategory;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryNew>>(
      future: futureCategory,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MealsPage(
                                category: snapshot.data![index].category!);
                          },
                        ),
                      );
                    },
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  snapshot.data![index].image!,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index].category ??
                                        'No Title',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Text(
                                      snapshot.data![index].desc!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600]!,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.lime,
            ),
          ),
        );
      },
    );
  }
}
