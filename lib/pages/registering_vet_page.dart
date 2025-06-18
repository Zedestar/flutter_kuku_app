import 'package:flutter/material.dart';

class VetRegistrationPage extends StatefulWidget {
  const VetRegistrationPage({super.key});

  @override
  State<VetRegistrationPage> createState() => _VetRegistrationPageState();
}

class _VetRegistrationPageState extends State<VetRegistrationPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int pageNumber) {
    setState(() {
      _currentPage = pageNumber;
    });
  }

  final List<Widget> _contents = [
    Column(
      children: [
        Text("Hey there this is the first page"),
        Text("This is just the start page the coming is greate")
      ],
    ),
    Column(
      children: [
        Text("Hey there this is the second page"),
        Text("Here we have just begging the journer for vet registration")
      ],
    ),
    Column(
      children: [
        Text("Hey there this is the third page"),
        Text("This is just a beggining of creating our vet")
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
              controller: _pageController,
              itemCount: _contents.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return _contents[index];
              }),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              ElevatedButton(onPressed: null, child: Text("Back")),
              ElevatedButton(onPressed: null, child: Text("Back")),
              ElevatedButton(onPressed: null, child: Text("Next")),
            ],
          ),
        )
      ],
    );
  }
}
