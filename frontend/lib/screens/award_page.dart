// import 'package:flutter/material.dart';

// class AwardPage extends StatefulWidget {
//   const AwardPage({Key? key}) : super(key: key);

//   @override
//   State<AwardPage> createState() => _AwardPageState();
// }

// class _AwardPageState extends State<AwardPage> {
//   // 수상경력 리스트
//   List<Map<String, String>> awards = [
//     {"title": "", "organization": "", "date": "", "details": ""}
//   ]; // 기본 1개의 입력 필드

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           '수상경력',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               children: [
//                 const Center(
//                   child: Text(
//                     '해당 직무와 관련이 높은 수상경력을 입력해주세요.\n최대 5개까지 입력이 가능합니다.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // 수상경력 입력 필드
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: awards.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 24),
//                       child: _buildAwardField(index),
//                     );
//                   },
//                 ),
//                 // 수상경력 추가 버튼
//                 if (awards.length < 5)
//                   TextButton.icon(
//                     onPressed: () {
//                       if (awards.length < 5) {
//                         setState(() {
//                           awards.add({
//                             "title": "",
//                             "organization": "",
//                             "date": "",
//                             "details": ""
//                           }); // 새 필드 추가
//                         });
//                       }
//                     },
//                     icon: const Icon(
//                       Icons.add,
//                       color: Color(0xFF908CFF),
//                     ),
//                     label: const Text(
//                       '수상 경력 추가',
//                       style: TextStyle(
//                         color: Color(0xFF908CFF),
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     style: TextButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 50),
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       side: const BorderSide(
//                         color: Color(0xFF908CFF),
//                         width: 1,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           // 입력 완료 버튼
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 print('입력 완료: $awards');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF908CFF),
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 '입력완료',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAwardField(int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // 수상명 입력 필드
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 onChanged: (value) {
//                   awards[index]["title"] = value;
//                 },
//                 decoration: InputDecoration(
//                   hintText: '수상명',
//                   hintStyle: const TextStyle(color: Colors.black38),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: Colors.grey),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: Colors.grey),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: Color(0xFF908CFF)),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             // 삭제 버튼
//             IconButton(
//               onPressed: () {
//                 setState(() {
//                   awards.removeAt(index);
//                 });
//               },
//               icon: const Icon(Icons.close, color: Colors.black38),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         // 기관명 입력 필드
//         TextField(
//           onChanged: (value) {
//             awards[index]["organization"] = value;
//           },
//           decoration: InputDecoration(
//             hintText: '기관명',
//             hintStyle: const TextStyle(color: Colors.black38),
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.grey),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.grey),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFF908CFF)),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         // 수상 연도 입력 필드
//         TextField(
//           onChanged: (value) {
//             awards[index]["date"] = value;
//           },
//           decoration: InputDecoration(
//             hintText: '수상 연도 ex) 24.01.01',
//             hintStyle: const TextStyle(color: Colors.black38),
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.grey),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.grey),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFF908CFF)),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         // 수상 내용 입력 필드
//         TextField(
//           onChanged: (value) {
//             awards[index]["details"] = value;
//           },
//           maxLines: 3,
//           decoration: InputDecoration(
//             hintText: '수상 내용을 입력해주세요.',
//             hintStyle: const TextStyle(color: Colors.black38),
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.grey),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.grey),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFF908CFF)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class AwardPage extends StatefulWidget {
  const AwardPage({Key? key}) : super(key: key);

  @override
  State<AwardPage> createState() => _AwardPageState();
}

class _AwardPageState extends State<AwardPage> {
  // 수상경력 리스트
  List<Map<String, String>> awards = [
    {"title": "", "organization": "", "date": "", "details": ""}
  ]; // 기본 1개의 입력 필드

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '수상경력',
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
                  child: Text(
                    '해당 직무와 관련이 높은 수상경력을 입력해주세요.\n최대 5개까지 입력이 가능합니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 수상경력 입력 필드
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: awards.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _buildAwardField(index),
                    );
                  },
                ),
                // 수상경력 추가 버튼
                if (awards.length < 5)
                  TextButton.icon(
                    onPressed: () {
                      if (awards.length < 5) {
                        setState(() {
                          awards.add({
                            "title": "",
                            "organization": "",
                            "date": "",
                            "details": ""
                          }); // 새 필드 추가
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xFF908CFF),
                    ),
                    label: const Text(
                      '수상 경력 추가',
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
              ],
            ),
          ),
          // 입력 완료 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print('입력 완료: $awards');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF908CFF),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '입력완료',
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

  Widget _buildAwardField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 수상명 입력 필드
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  awards[index]["title"] = value;
                },
                decoration: InputDecoration(
                  hintText: '수상명',
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
            ),
            const SizedBox(width: 8),
            // 삭제 버튼
            IconButton(
              onPressed: () {
                setState(() {
                  awards.removeAt(index);
                });
              },
              icon: const Icon(Icons.close, color: Colors.black38),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 기관명 입력 필드
        TextField(
          onChanged: (value) {
            awards[index]["organization"] = value;
          },
          decoration: InputDecoration(
            hintText: '기관명',
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
        const SizedBox(height: 16),
        // 수상 연도 DatePicker 필드
        GestureDetector(
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (selectedDate != null) {
              setState(() {
                awards[index]["date"] =
                    "${selectedDate.year}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.day.toString().padLeft(2, '0')}";
              });
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: '수상 연도 ex) 24.01.01',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  awards[index]["date"]!.isEmpty
                      ? '수상 연도 ex) 24.01.01'
                      : awards[index]["date"]!,
                  style: TextStyle(
                    color: awards[index]["date"]!.isEmpty
                        ? Colors.black38
                        : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black38,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 수상 내용 입력 필드
        TextField(
          onChanged: (value) {
            awards[index]["details"] = value;
          },
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '수상 내용을 입력해주세요.',
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
}
