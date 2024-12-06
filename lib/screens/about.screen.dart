import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Về Chúng Tôi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xfff5f7fa),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chào mừng đến với chúng tôi!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/aya.png',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSection(
                title: 'Giới thiệu',
                content:
                    'Chúng tôi là một công ty tiên phong trong lĩnh vực cung cấp các giải pháp sáng tạo và đổi mới. Với tầm nhìn trở thành một trong những thương hiệu hàng đầu trong ngành, chúng tôi cam kết mang lại giá trị thực cho khách hàng và cộng đồng.',
              ),
              _buildSection(
                title: 'Sứ mệnh của chúng tôi:',
                content:
                    'Chúng tôi cam kết cung cấp các sản phẩm chất lượng cao, luôn đổi mới và không ngừng cải tiến để đáp ứng nhu cầu ngày càng cao của khách hàng. Sứ mệnh của chúng tôi là giúp đỡ cộng đồng, mang lại những trải nghiệm tuyệt vời và phát triển bền vững.',
              ),
              _buildSection(
                title: 'Tầm nhìn của chúng tôi:',
                content:
                    'Tầm nhìn của chúng tôi là trở thành một đối tác đáng tin cậy, mang đến những sản phẩm và dịch vụ sáng tạo giúp cải thiện cuộc sống của mọi người. Chúng tôi đặt mục tiêu phát triển không chỉ về quy mô mà còn về sự bền vững trong mọi lĩnh vực hoạt động.',
              ),
              _buildSection(
                title: 'Đội ngũ sáng lập:',
                content:
                    'Được sáng lập bởi một đội ngũ gồm các chuyên gia hàng đầu trong ngành, chúng tôi có đủ kiến thức và kinh nghiệm để mang đến những giải pháp hiệu quả và bền vững cho khách hàng.',
              ),
              _buildSection(
                title: 'Liên hệ với chúng tôi:',
                content:
                    'Email: loc.phan2113971@hcmut.edu.vn\nSố điện thoại: +84 123 456 789',
                isContact: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title,
      required String content,
      bool isContact = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
