import '../models/book_model.dart';
import '../models/word.dart';
import '../models/word_book.dart';

class SeedData {
  static List<WordBook> get books => [
        Book(
          bookId: 'seed_basic',
          bookName: '基础1000词',
          description: '最常用的1000个英语基础词汇',
          category: 'basic',
          coverColor: '#4CAF50',
        ),
        Book(
          bookId: 'seed_cet4',
          bookName: 'CET4 核心词汇',
          description: '大学英语四级考试核心词汇',
          category: 'cet4',
          coverColor: '#2196F3',
        ),
        Book(
          bookId: 'seed_cet6',
          bookName: 'CET6 核心词汇',
          description: '大学英语六级考试核心词汇',
          category: 'cet6',
          coverColor: '#9C27B0',
        ),
        Book(
          bookId: 'seed_ielts',
          bookName: '雅思高频词汇',
          description: 'IELTS 考试高频核心词汇',
          category: 'ielts',
          coverColor: '#FF9800',
        ),
        Book(
          bookId: 'seed_toefl',
          bookName: 'TOEFL 高频词汇',
          description: '托福考试高频核心词汇',
          category: 'toefl',
          coverColor: '#F44336',
        ),
      ];

  static List<Word> wordsForBook(String bookId, String category) {
    final samples = _samplesByCategory[category] ?? _commonSamples;
    return samples
        .asMap()
        .entries
        .map(
          (entry) => BookWord(
            id: '${bookId}_${entry.key + 1}',
            word: entry.value.english,
            definitionCn: entry.value.chinese,
            phoneticUk: entry.value.phonetic ?? '',
            partOfSpeech: entry.value.partOfSpeech ?? '',
            legacyExamples: entry.value.examples,
            bookIds: [bookId],
          ),
        )
        .toList();
  }
}

class _WordSample {
  const _WordSample({
    required this.english,
    required this.chinese,
    this.phonetic,
    this.partOfSpeech,
    this.examples,
  });

  final String english;
  final String chinese;
  final String? phonetic;
  final String? partOfSpeech;
  final List<String>? examples;
}

const _commonSamples = [
  _WordSample(
    english: 'abandon',
    chinese: '放弃；抛弃',
    phonetic: '/əˈbændən/',
    partOfSpeech: 'v.',
    examples: ['He abandoned his plan to travel abroad.'],
  ),
  _WordSample(
    english: 'ability',
    chinese: '能力；才能',
    phonetic: '/əˈbɪləti/',
    partOfSpeech: 'n.',
    examples: ['She has the ability to solve complex problems.'],
  ),
  _WordSample(
    english: 'absorb',
    chinese: '吸收；使全神贯注',
    phonetic: '/əbˈzɔːrb/',
    partOfSpeech: 'v.',
    examples: ['Plants absorb water through their roots.'],
  ),
  _WordSample(
    english: 'abstract',
    chinese: '抽象的；摘要',
    phonetic: '/ˈæbstrækt/',
    partOfSpeech: 'adj.',
    examples: ['The concept is too abstract for beginners.'],
  ),
  _WordSample(
    english: 'abundant',
    chinese: '丰富的；充裕的',
    phonetic: '/əˈbʌndənt/',
    partOfSpeech: 'adj.',
    examples: ['The region has abundant natural resources.'],
  ),
];

final _samplesByCategory = <String, List<_WordSample>>{
  'basic': [
    ..._commonSamples,
    const _WordSample(
      english: 'accept',
      chinese: '接受；承认',
      phonetic: '/əkˈsept/',
      partOfSpeech: 'v.',
      examples: ['Please accept my apology.'],
    ),
    const _WordSample(
      english: 'achieve',
      chinese: '实现；达到',
      phonetic: '/əˈtʃiːv/',
      partOfSpeech: 'v.',
      examples: ['She achieved her goal through hard work.'],
    ),
    const _WordSample(
      english: 'active',
      chinese: '积极的；活跃的',
      phonetic: '/ɑːˈtɪv/',
      partOfSpeech: 'adj.',
      examples: ['He leads an active lifestyle.'],
    ),
  ],
  'cet4': [
    ..._commonSamples,
    const _WordSample(
      english: 'accommodate',
      chinese: '容纳；适应',
      phonetic: '/əˈkɒmədeɪt/',
      partOfSpeech: 'v.',
      examples: ['The hotel can accommodate 200 guests.'],
    ),
    const _WordSample(
      english: 'accumulate',
      chinese: '积累；积聚',
      phonetic: '/əˈkjuːmjəleɪt/',
      partOfSpeech: 'v.',
      examples: ['Dust tends to accumulate on shelves.'],
    ),
    const _WordSample(
      english: 'accurate',
      chinese: '准确的；精确的',
      phonetic: '/ˈækjərət/',
      partOfSpeech: 'adj.',
      examples: ['The report provides accurate data.'],
    ),
  ],
  'cet6': [
    ..._commonSamples,
    const _WordSample(
      english: 'alleviate',
      chinese: '减轻；缓和',
      phonetic: '/əˈliːvieɪt/',
      partOfSpeech: 'v.',
      examples: ['Medicine can alleviate the pain.'],
    ),
    const _WordSample(
      english: 'ambiguous',
      chinese: '模糊的；歧义的',
      phonetic: '/æmˈbɪɡjuəs/',
      partOfSpeech: 'adj.',
      examples: ['His answer was deliberately ambiguous.'],
    ),
    const _WordSample(
      english: 'analogy',
      chinese: '类比；相似',
      phonetic: '/əˈnælədʒi/',
      partOfSpeech: 'n.',
      examples: ['She drew an analogy between the two cases.'],
    ),
  ],
  'ielts': [
    ..._commonSamples,
    const _WordSample(
      english: 'articulate',
      chinese: '清晰表达；口齿伶俐的',
      phonetic: '/ɑːˈtɪkjuleɪt/',
      partOfSpeech: 'v./adj.',
      examples: ['She articulated her ideas clearly.'],
    ),
    const _WordSample(
      english: 'coherent',
      chinese: '连贯的；一致的',
      phonetic: '/koʊˈhɪrənt/',
      partOfSpeech: 'adj.',
      examples: ['Write a coherent essay on the topic.'],
    ),
    const _WordSample(
      english: 'deteriorate',
      chinese: '恶化；退化',
      phonetic: '/dɪˈtɪriəreɪt/',
      partOfSpeech: 'v.',
      examples: ['His health began to deteriorate.'],
    ),
  ],
  'toefl': [
    ..._commonSamples,
    const _WordSample(
      english: 'comprehensive',
      chinese: '全面的；综合的',
      phonetic: '/ˌkɒmprɪˈhensɪv/',
      partOfSpeech: 'adj.',
      examples: ['The guide offers comprehensive coverage.'],
    ),
    const _WordSample(
      english: 'hypothesis',
      chinese: '假设；假说',
      phonetic: '/haɪˈpɒθəsɪs/',
      partOfSpeech: 'n.',
      examples: ['Scientists tested the hypothesis.'],
    ),
    const _WordSample(
      english: 'phenomenon',
      chinese: '现象；非凡的人',
      phonetic: '/fəˈnɒmɪnən/',
      partOfSpeech: 'n.',
      examples: ['This is a rare natural phenomenon.'],
    ),
  ],
};