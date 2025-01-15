import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Industrial_Group extends StatefulWidget {
  final List<String> initialIndustries; // 초기 산업군 리스트

  const Industrial_Group({Key? key, required this.initialIndustries})
      : super(key: key);

  @override
  State<Industrial_Group> createState() => Industrial_Group_State();
}

class Industrial_Group_State extends State<Industrial_Group> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    for (var industry in widget.initialIndustries) {
      controllers.add(TextEditingController(text: industry));
    }
    if (controllers.isEmpty) {
      controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget buildIndustryField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '산업군 ${index + 1}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 352,
          height: 47,
          child: TextFormField(
            controller: controllers[index],
            decoration: InputDecoration(
              hintText: "ex) 헬스케어, 금융, 패션, 영화, 교육",
              hintStyle:
                  const TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '산업군',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, controllers.map((e) => e.text).toList());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                '산업군은 최대 3개까지 입력이 가능합니다.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: controllers.length,
                itemBuilder: (context, index) {
                  return buildIndustryField(index);
                },
              ),
            ),
            if (controllers.length < 3)
              Center(
                child: SizedBox(
                  width: 352,
                  height: 47,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        controllers.add(TextEditingController());
                      });
                    },
                    style: TextButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFF908CFF), width: 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(FontAwesomeIcons.plus, size: 12),
                        SizedBox(width: 10),
                        Text(
                          '산업군 추가',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(
                      context, controllers.map((e) => e.text).toList());
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF878CEF),
                  minimumSize: const Size(352, 47),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "입력완료",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}