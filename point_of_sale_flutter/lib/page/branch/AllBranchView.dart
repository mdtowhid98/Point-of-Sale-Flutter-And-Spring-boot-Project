import 'package:flutter/material.dart';
import 'package:point_of_sale/model/BranchModel.dart';
import 'package:point_of_sale/page/branch/CreateBranch.dart';
import 'package:point_of_sale/page/branch/UpdateBranch.dart';
import 'package:point_of_sale/service/BranchService.dart';

class AllBranchesView extends StatefulWidget {
  const AllBranchesView({super.key});

  @override
  State<AllBranchesView> createState() => _AllBranchesViewState();
}

class _AllBranchesViewState extends State<AllBranchesView> {
  late Future<List<Branch>> futureBranches;

  final List<Color> borderColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    futureBranches = BranchService().fetchBranches();
  }

  Future<void> _deleteBranch(Branch branch) async {
    await BranchService().deleteBranch(branch.id);
    setState(() {
      futureBranches = BranchService().fetchBranches();
    });
  }

  void _updateBranch(Branch branch) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateBranchView(branch: branch)),
    ).then((_) {
      setState(() {
        futureBranches = BranchService().fetchBranches();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Branches'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellowAccent, Colors.green, Colors.lightGreenAccent, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Branch>>(
              future: futureBranches,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No branches available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final branch = snapshot.data![index];
                      final borderColor = borderColors[index % borderColors.length];

                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: borderColor, width: 2), // Set the border color
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Expanded column for branch details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ID: ${branch.id ?? 'Unnamed ID'}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Branch Name: ${branch.branchName ?? 'No branch available'}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'Location: ${branch.location ?? 'No location available'}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              // Row for action buttons
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => _updateBranch(branch),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Delete Branch'),
                                            content: Text('Are you sure you want to delete this branch?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _deleteBranch(branch);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateBranch()),
          ).then((_) {
            setState(() {
              futureBranches = BranchService().fetchBranches();
            });
          });
        },
        backgroundColor: Colors.lightGreenAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
