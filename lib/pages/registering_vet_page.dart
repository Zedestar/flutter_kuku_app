import 'package:flutter/material.dart';
import 'package:kuku_app/constants/constant.dart';

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
    Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(),
          SizedBox(
            height: 30,
          ),
          TextFormField(),
        ],
      ),
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Hey there this is the second page"),
        Text("Here we have just begging the journer for vet registration")
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Hey there this is the third page"),
        Text("This is just a beggining of creating our vet")
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _contents.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return _contents[index];
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 40,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kcolor,
                    ),
                    child: Text("Back")),
                Row(
                  children: List.generate(
                    _contents.length,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 5),
                      height: 8,
                      width: _currentPage == index ? 20 : 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _currentPage == index ? kcolor : Colors.grey,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: null, child: Text("Next")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
