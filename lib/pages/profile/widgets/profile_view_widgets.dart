import 'package:flutter/material.dart';
import '../../chat/message_page.dart';
import '../styles/user_profile_styles.dart';

class HeaderElements extends StatelessWidget {
  final String name;
  final String age;
  final bool isUser;
  final String userId;
  final String photoURL;

  const HeaderElements({
    super.key,
    required this.name,
    required this.age,
    required this.isUser,
    required this.userId,
    required this.photoURL,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Container(
            width: ProfileStyles.containerWidth,
            padding: ProfileStyles.boxPadding,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            )),
      ],
    );
  }
}

//image box
class ProfileImage extends StatefulWidget {
  final String? imageUrl;
  final List<dynamic>? profileImages;

  const ProfileImage({super.key, this.imageUrl, this.profileImages});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  final PageController _pageController = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.profileImages ?? [];
    final hasCarousel = images.isNotEmpty;

    return Container(
      height: 500,
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration(context),
      clipBehavior: Clip.hardEdge,
      child: hasCarousel
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      height: 4,
                      width: 25,
                      color: _index == i
                          ? Theme.of(context).colorScheme.tertiaryFixed
                          : Theme.of(context).colorScheme.tertiary,
                    );
                  }),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _index = i),
                    children: images.map((img) {
                      return Image.network(
                        img,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Center(child: Icon(Icons.person, size: 100)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )
          : _buildSingleImageOrFallback(),
    );
  }

  Widget _buildSingleImageOrFallback() {
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.person, size: 100)),
      );
    } else {
      return const Center(child: Icon(Icons.person, size: 100));
    }
  }
}

class AboutMe extends StatelessWidget {
  final String bio;
  const AboutMe({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    //doesn't render until data is loaded
    return bio != ""
        ? Container(
            width: ProfileStyles.containerWidth,
            decoration: ProfileStyles.boxDecoration(context),
            padding: ProfileStyles.boxPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("About Me", style: ProfileStyles.boxHeader(context)),
                Text(bio, style: ProfileStyles.boxText(context))
              ],
            ),
          )
        : const SizedBox(height: 0);
  }
}

//key info box
class KeyInfo extends StatelessWidget {
  final String lookingFor;
  final String relationshipStyle;
  final String height;
  final String age;
  final double? distance;
  final String? location;
  final List<dynamic> sexuality;
  final List<dynamic> genderIdentity;
  final List<dynamic> pronouns;
  final String relationshipStatus;
  final List<dynamic> genderExpression;

  const KeyInfo(
      {super.key,
      required this.lookingFor,
      required this.relationshipStyle,
      required this.height,
      required this.age,
      required this.distance,
      required this.location,
      required this.sexuality,
      required this.genderIdentity,
      required this.pronouns,
      required this.relationshipStatus,
      required this.genderExpression});

  @override
  Widget build(BuildContext context) {
    //list of fields in key info
    final List<Map<String, dynamic>> fields = [
      {
        'label': 'Distance',
        'value': distance != null
            ? '${distance!.toStringAsFixed(1)} km away'
            : 'Unknown',
        'icon': Icons.location_on_outlined
      },
      {
        'label': 'Age',
        'value': age,
        'icon': Icons.assignment_ind_rounded
      },
      {'label': 'Location', 'value': location, 'icon': Icons.home_outlined},
      {
        'label': 'Sexuality',
        'value': sexuality.join(', '),
        'icon': Icons.circle_outlined
      },
      {
        'label': 'Pronouns',
        'value': pronouns.join(', '),
        'icon': Icons.chat_bubble_outline
      },
      {'label': 'Height', 'value': height, 'icon': Icons.height},
      {'label': 'Looking For', 'value': lookingFor, 'icon': Icons.search},
      {
        'label': 'Relationship Style',
        'value': relationshipStyle,
        'icon': Icons.handshake
      },
      {
        'label': 'Relationship Status',
        'value': relationshipStatus,
        'icon': Icons.star_outline_sharp
      },
      {
        'label': 'Gender Expression',
        'value': genderExpression.join(', '),
        'icon': Icons.person_2_outlined
      },
    ];

    final fieldsFiltered = fields.where((f) {
      final v = f['value'];
      return v != 'Unknown' && v.toString().isNotEmpty;
    }).toList();

    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration(context),
      padding: ProfileStyles.boxPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Key Info",
              style: ProfileStyles.boxHeader(context),
            ),
          ),
          const SizedBox(height: 8),
          // List of key info rows with dividers
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(), // let parent scroll
            shrinkWrap: true, // important so it fits inside the column
            itemCount: fieldsFiltered.length,
            separatorBuilder: (context, index) => const Divider(
              height: 20,
              thickness: 2,
              color: Color(0xFFD461A6),
            ),
            itemBuilder: (context, index) {
              final field = fieldsFiltered[index];

              // skip empty fields
              if (field['value'] == 'Unknown' ||
                  field['value'].toString().isEmpty) {
                return const SizedBox.shrink();
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Text(field['label'] ?? '', style: ProfileStyles.boxText(context)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      Icon(field['icon'], color: Color(0xFFD461A6), size: 20),
                      Flexible(
                        child: Text(
                          field['value'],
                          style: ProfileStyles.boxText(context),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class FieldsBox extends StatelessWidget {
  final List<dynamic> items;
  final String label;

  const FieldsBox({super.key, required this.items, required this.label});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox();

    // Convert list to comma-separated string
    final String formattedItems = items.join(', ');

    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration(context),
      padding: ProfileStyles.boxPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: ProfileStyles.boxHeader(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedItems,
            style: ProfileStyles.boxText(context),
          ),
        ],
      ),
    );
  }
}
