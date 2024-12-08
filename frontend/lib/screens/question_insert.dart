import 'package:flutter/material.dart';
import 'loading_screen.dart';

class QuestionInsert extends StatefulWidget {
  const QuestionInsert({Key? key}) : super(key: key);

  @override
  State<QuestionInsert> createState() => _QuestionInsertState();
}

class _QuestionInsertState extends State<QuestionInsert> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final List<TextEditingController> questionControllers = [
    TextEditingController()
  ]; // 초기 문항 하나만 생성

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '자기소개서 추가',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                const Center(
                  child: Column(
                    children: [
                      Text(
                        '자기소개서 문항 입력',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '자기소개서 문항은 최대 5개까지 입력이 가능하며,\n1000자 이내로 답변을 해줍니다.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff555555),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                // 회사명 및 직무명 입력 필드 (가로 배치)
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: '회사명',
                        hint: '회사명을 입력해주세요.',
                        controller: companyNameController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: '직무명',
                        hint: '직무명을 입력해주세요.',
                        controller: jobTitleController,
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 16),
                // 제목 입력 필드
                _buildTextField(
                  label: '자기소개서 제목',
                  hint: '제목을 입력해주세요.',
                  controller: titleController,
                ),


                const SizedBox(height: 16),
                // 문항 입력 필드
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questionControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildTextField(
                        label: '자기소개서 문항 ${index + 1}',
                        hint: '문항을 입력해주세요.',
                        controller: questionControllers[index],
                      ),
                    );
                  },
                ),
                // 문항 추가 버튼
                if (questionControllers.length < 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          questionControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFF908CFF),
                      ),
                      label: const Text(
                        '문항 추가',
                        style: TextStyle(
                          color: Color(0xFF908CFF),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: const BorderSide(
                          color: Color(0xFF908CFF),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // 입력 완료 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF908CFF),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '입력 완료',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 공통 텍스트 필드
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF908CFF)),
            ),
          ),
        ),
      ],
    );
  }

  // 제출 버튼 클릭 시
  void _handleSubmit() {
    // 모든 필드가 비어있는지 확인
    if (titleController.text.trim().isEmpty ||
        companyNameController.text.trim().isEmpty ||
        jobTitleController.text.trim().isEmpty ||
        questionControllers.any((controller) => controller.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    // 입력값을 처리
    final title = titleController.text.trim();
    final companyName = companyNameController.text.trim();
    final jobTitle = jobTitleController.text.trim();
    final questions =
    questionControllers.map((controller) => controller.text.trim()).toList();

    print('제목: $title');
    print('회사명: $companyName');
    print('직무명: $jobTitle');
    print('문항: $questions');

    // 다음 화면으로 데이터 전달
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(
          questions: questions,
          title: title,
          companyName: companyName,
          jobTitle: jobTitle,
        ),
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';

class QuestionInsertVer2 extends StatefulWidget {
  const QuestionInsertVer2({Key? key}) : super(key: key);

  @override
  State<QuestionInsertVer2> createState() => _QuestionInsertVer2State();
}

class _QuestionInsertVer2State extends State<QuestionInsertVer2> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final List<TextEditingController> questionControllers = [
    TextEditingController()
  ]; // 초기 문항 하나만 생성

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '자기소개서 추가',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                const Center(
                  child: Column(
                    children: [
                      Text(
                        '자기소개서 문항 입력',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '자기소개서 문항은 최대 5개까지 입력이 가능하며,\n1000자 이내로 답변을 해줍니다.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff555555),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // 제목 입력 필드
                _buildTextField(
                  label: '자기소개서 제목',
                  hint: '제목을 입력해주세요.',
                  controller: titleController,
                ),
                const SizedBox(height: 16),
                // 회사명 및 직무명 입력 필드 (가로 배치)
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: '회사명',
                        hint: '회사명을 입력해주세요.',
                        controller: companyNameController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: '직무명',
                        hint: '직무명을 입력해주세요.',
                        controller: jobTitleController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 문항 입력 필드
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questionControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildTextField(
                        label: '자기소개서 문항 ${index + 1}',
                        hint: '문항을 입력해주세요.',
                        controller: questionControllers[index],
                      ),
                    );
                  },
                ),
                // 문항 추가 버튼
                if (questionControllers.length < 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          questionControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFF908CFF),
                      ),
                      label: const Text(
                        '문항 추가',
                        style: TextStyle(
                          color: Color(0xFF908CFF),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: const BorderSide(
                          color: Color(0xFF908CFF),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // 입력 완료 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF908CFF),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '입력 완료',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 공통 텍스트 필드
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF908CFF)),
            ),
          ),
        ),
      ],
    );
  }

  // 제출 버튼 클릭 시
  void _handleSubmit() {
    if (titleController.text.isEmpty ||
        companyNameController.text.isEmpty ||
        jobTitleController.text.isEmpty ||
        questionControllers.any((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    print('제목: ${titleController.text}');
    print('회사명: ${companyNameController.text}');
    print('직무명: ${jobTitleController.text}');
    print('문항: ${questionControllers.map((c) => c.text).toList()}');
  }
}


 */