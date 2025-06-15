import 'package:flutter/material.dart';

class HelpSearchBar extends StatelessWidget {
  final ValueChanged<String>onChanged;

  const HelpSearchBar( {
      super.key, required this.onChanged
    }

  );

  @override Widget build(BuildContext context) {
    final theme=Theme.of(context);

    return TextField(onChanged: onChanged,
      decoration: InputDecoration(prefixIcon: const Icon(Icons.search),
        hintText: 'Cari bantuan...',
        hintStyle: theme.textTheme.bodySmall,
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: theme.textTheme.bodyMedium,
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem( {
      super.key,
      required this.question,
      required this.answer,
    }

  );

  @override State<FAQItem>createState()=>_FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool expanded=false;

  @override Widget build(BuildContext context) {
    final theme=Theme.of(context);

    return Card(color: theme.cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(onTap: ()=> setState(()=> expanded= !expanded),
        child: Padding(padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [ Text(widget.question,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (expanded) ...[ const SizedBox(height: 8),
            Text(widget.answer,
              style: theme.textTheme.bodySmall,
            ),
            ],
            ],
          ),
        ),
      ),
    );
  }
}

class HelpCategorySection extends StatelessWidget {
  final String title;
  final List<Map<String,
  String>>faqs;
  final String filter;

  const HelpCategorySection( {
      super.key,
      required this.title,
      required this.faqs,
      this.filter='',
    }

  );

  @override Widget build(BuildContext context) {
    final isDarkMode=Theme.of(context).brightness==Brightness.dark;

    final filteredFaqs=faqs.where((faq) {
        return filter.isEmpty || faq['question'] !.toLowerCase().contains(filter.toLowerCase()) || faq['answer'] !.toLowerCase().contains(filter.toLowerCase());
      }

    ).toList();

    if (filteredFaqs.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(builder: (context, constraints) {
        return Container(width: constraints.maxWidth,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [ Text(title,
              style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            ...filteredFaqs.map((faq)=> FAQItem(question: faq['question'] !,
                answer: faq['answer'] !,
              ),
            ),
            const SizedBox(height: 24),
            ],
          ),
        );
      }

      ,
    );
  }
}