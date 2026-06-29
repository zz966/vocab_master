import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BOOK_PATH = ROOT / "assets" / "books" / "test_40.json"
META_PATH = Path(__file__).resolve().parent / "test_40_word_meta.json"
SYNONYM_MEANINGS_PATH = Path(__file__).resolve().parent / "synonym_meanings.json"
LEVEL4_PATH = ROOT / "assets" / "vocab" / "Level4_1.json"
CONTENT_MARKER = "content-v7"

PHONETICS = {
    "adrift": ("/əˈdrɪft/", "/əˈdrɪft/"),
    "aftermath": ("/ˈɑːftəmæθ/", "/ˈæftərmæθ/"),
    "afterworld": ("/ˈɑːftəwɜːld/", "/ˈæftərwɜːrld/"),
    "ample": ("/ˈæmpl/", "/ˈæmpl/"),
    "ascertain": ("/ˌæsəˈteɪn/", "/ˌæsərˈteɪn/"),
    "assure": ("/əˈʃʊə(r)/", "/əˈʃʊr/"),
    "attain": ("/əˈteɪn/", "/əˈteɪn/"),
    "autopsy": ("/ˈɔːtɒpsi/", "/ˈɔːtɑːpsi/"),
    "Bible": ("/ˈbaɪbl/", "/ˈbaɪbl/"),
    "charitable": ("/ˈtʃærətəbl/", "/ˈtʃærətəbl/"),
    "combination": ("/ˌkɒmbɪˈneɪʃn/", "/ˌkɑːmbɪˈneɪʃn/"),
    "concept": ("/ˈkɒnsept/", "/ˈkɑːnsept/"),
    "congress": ("/ˈkɒŋɡres/", "/ˈkɑːŋɡrəs/"),
    "consequence": ("/ˈkɒnsɪkwəns/", "/ˈkɑːnsəkwens/"),
    "contagious": ("/kənˈteɪdʒəs/", "/kənˈteɪdʒəs/"),
    "contemporary": ("/kənˈtemprəri/", "/kənˈtempəreri/"),
    "contempt": ("/kənˈtempt/", "/kənˈtempt/"),
    "crave": ("/kreɪv/", "/kreɪv/"),
    "deprive": ("/dɪˈpraɪv/", "/dɪˈpraɪv/"),
    "detect": ("/dɪˈtekt/", "/dɪˈtekt/"),
    "deter": ("/dɪˈtɜː(r)/", "/dɪˈtɜːr/"),
    "disgrace": ("/dɪsˈɡreɪs/", "/dɪsˈɡreɪs/"),
    "dispel": ("/dɪˈspel/", "/dɪˈspel/"),
    "dispute": ("/dɪˈspjuːt/", "/dɪˈspjuːt/"),
    "disseminate": ("/dɪˈsemɪneɪt/", "/dɪˈsemɪneɪt/"),
    "dove": ("/dʌv/", "/dʌv/"),
    "drag": ("/dræɡ/", "/dræɡ/"),
    "ensure": ("/ɪnˈʃʊə(r)/", "/ɪnˈʃʊr/"),
    "especially": ("/ɪˈspeʃəli/", "/ɪˈspeʃəli/"),
    "expel": ("/ɪkˈspel/", "/ɪkˈspel/"),
    "fate": ("/feɪt/", "/feɪt/"),
    "federal": ("/ˈfedərəl/", "/ˈfedərəl/"),
    "generations": ("/ˌdʒenəˈreɪʃnz/", "/ˌdʒenəˈreɪʃnz/"),
    "grit": ("/ɡrɪt/", "/ɡrɪt/"),
    "gritty": ("/ˈɡrɪti/", "/ˈɡrɪti/"),
    "gutter": ("/ˈɡʌtə(r)/", "/ˈɡʌtər/"),
    "hippie": ("/ˈhɪpi/", "/ˈhɪpi/"),
    "immortality": ("/ˌɪmɔːˈtæləti/", "/ˌɪmɔːrˈtæləti/"),
    "indolence": ("/ˈɪndələns/", "/ˈɪndələns/"),
    "insecure": ("/ˌɪnsɪˈkjʊə(r)/", "/ˌɪnsɪˈkjʊr/"),
}

MULTI_POS_DEFINITIONS = {
    "disgrace": [
        {"partOfSpeech": "n.", "meaning": "耻辱"},
        {"partOfSpeech": "v.", "meaning": "使丢脸"},
    ],
    "dispute": [
        {"partOfSpeech": "v.", "meaning": "争论；对…提出质疑"},
        {"partOfSpeech": "n.", "meaning": "争端；争论"},
    ],
    "drag": [
        {"partOfSpeech": "v.", "meaning": "拖拽；吃力地往前拉"},
        {"partOfSpeech": "n.", "meaning": "累赘；拖曳"},
    ],
}

WORD_EXAMPLES = {
    "adrift": [
        ("The boat was set adrift in the open sea.", "小船被放到公海上漂流。"),
        ("He felt adrift after losing his job.", "失业后他感到茫然无措。"),
        ("The survivors were found adrift on a raft.", "幸存者在筏子上漂流时被发现。"),
    ],
    "aftermath": [
        ("In the aftermath of the storm, roads were blocked.", "暴风雨过后，道路被堵住了。"),
        ("The country struggled in the aftermath of war.", "战后该国陷入困境。"),
        ("She helped rebuild the town in the aftermath of the earthquake.", "地震后她帮助重建小镇。"),
    ],
    "afterworld": [
        ("Ancient Egyptians believed in an afterworld.", "古埃及人相信有来世。"),
        ("The poem describes a peaceful afterworld.", "这首诗描绘了一个宁静的阴间。"),
        ("Many cultures have stories about the afterworld.", "许多文化都有关于来世的传说。"),
    ],
    "ample": [
        ("There is ample evidence to support the claim.", "有充分证据支持这一说法。"),
        ("The hotel provides ample space for meetings.", "酒店提供充足的会议空间。"),
        ("We have ample time to finish the project.", "我们有充足的时间完成项目。"),
    ],
    "ascertain": [
        ("Police are trying to ascertain the cause of the fire.", "警方正试图查明起火原因。"),
        ("We need to ascertain whether the data is accurate.", "我们需要确认数据是否准确。"),
        ("It was difficult to ascertain the truth.", "很难查明真相。"),
    ],
    "assure": [
        ("I assure you that everything will be fine.", "我向你保证一切都会好起来。"),
        ("The doctor assured the patient of a full recovery.", "医生向病人保证会完全康复。"),
        ("She assured herself that the door was locked.", "她确认门已经锁好。"),
    ],
    "attain": [
        ("She worked hard to attain her goals.", "她努力以实现目标。"),
        ("The company hopes to attain higher profits this year.", "公司希望今年获得更高利润。"),
        ("He finally attained the rank of professor.", "他终于获得了教授职称。"),
    ],
    "autopsy": [
        ("The autopsy revealed the cause of death.", "尸检揭示了死因。"),
        ("An autopsy was performed on the victim.", "对受害者进行了尸检。"),
        ("The report was based on the autopsy findings.", "报告基于尸检结果。"),
    ],
    "Bible": [
        ("She reads the Bible every morning.", "她每天早晨读圣经。"),
        ("The Bible has influenced Western culture deeply.", "圣经深刻影响了西方文化。"),
        ("He quoted a passage from the Holy Bible.", "他引用了《圣经》中的一段话。"),
    ],
    "charitable": [
        ("She is known for her charitable work.", "她以慈善工作闻名。"),
        ("The organization runs charitable programs for children.", "该机构为儿童开展慈善项目。"),
        ("He made a charitable donation to the hospital.", "他向医院进行了慈善捐赠。"),
    ],
    "combination": [
        ("The dish is a combination of sweet and sour flavors.", "这道菜是酸甜口味的结合。"),
        ("A combination of factors led to the accident.", "多种因素共同导致了事故。"),
        ("This lock requires a combination of numbers.", "这把锁需要一组数字密码。"),
    ],
    "concept": [
        ("The concept of time varies across cultures.", "时间的概念因文化而异。"),
        ("She explained the basic concept clearly.", "她清楚地解释了基本概念。"),
        ("This design concept won the competition.", "这一设计理念赢得了比赛。"),
    ],
    "congress": [
        ("Congress passed a new education bill.", "国会通过了一项新的教育法案。"),
        ("Members of congress debated the issue for hours.", "国会议员就该问题辩论了数小时。"),
        ("The president addressed a joint session of congress.", "总统向国会联席会议发表了讲话。"),
    ],
    "consequence": [
        ("Every action has a consequence.", "每个行动都有后果。"),
        ("He faced the consequence of his mistake.", "他承担了错误的后果。"),
        ("As a consequence, the meeting was cancelled.", "因此，会议被取消了。"),
    ],
    "contagious": [
        ("The flu is highly contagious.", "流感传染性很强。"),
        ("Her laughter was contagious.", "她的笑声很有感染力。"),
        ("Keep away if the disease is contagious.", "如果疾病有传染性，请远离。"),
    ],
    "contemporary": [
        ("She enjoys contemporary art.", "她喜欢当代艺术。"),
        ("The novel reflects contemporary society.", "这部小说反映了当代社会。"),
        (
            "Shakespeare and his contemporary writers shaped English drama.",
            "莎士比亚及其同时代作家塑造了英国戏剧。",
        ),
    ],
    "contempt": [
        ("He showed contempt for the rules.", "他对规则表现出蔑视。"),
        ("She looked at him with contempt.", "她轻蔑地看着他。"),
        ("Contempt of court is a serious offense.", "藐视法庭是严重违法行为。"),
    ],
    "crave": [
        ("After exercise, I crave a cold drink.", "运动后，我渴望喝杯冷饮。"),
        ("She craves attention from her peers.", "她渴望得到同伴的关注。"),
        ("Many people crave stability in uncertain times.", "许多人在动荡时期渴望稳定。"),
    ],
    "deprive": [
        ("No one should deprive children of education.", "任何人都不应剥夺儿童受教育的权利。"),
        ("Lack of sleep can deprive you of energy.", "睡眠不足会使你失去精力。"),
        ("The law deprives felons of voting rights.", "法律剥夺重罪犯的选举权。"),
    ],
    "detect": [
        ("The sensor can detect small changes in temperature.", "传感器能检测到温度的微小变化。"),
        ("Doctors detected the disease early.", "医生早期发现了这种疾病。"),
        ("It is hard to detect lies without evidence.", "没有证据很难识破谎言。"),
    ],
    "deter": [
        ("High fines deter people from speeding.", "高额罚款威慑人们超速。"),
        ("Security cameras deter shoplifting.", "监控摄像头能震慑扒窃行为。"),
        ("Nothing could deter her from pursuing her dream.", "没有什么能阻止她追求梦想。"),
    ],
    "disgrace": [
        ("His behavior was a disgrace to the family.", "他的行为是家族的耻辱。"),
        ("The scandal brought disgrace upon the company.", "丑闻给公司带来了耻辱。"),
        ("He felt disgrace after the public apology.", "公开道歉后他感到羞愧。"),
    ],
    "dispel": [
        ("Sunlight dispelled the morning fog.", "阳光驱散了晨雾。"),
        ("The speech helped dispel their fears.", "演讲帮助消除了他们的恐惧。"),
        ("Facts can dispel rumors quickly.", "事实能迅速澄清谣言。"),
    ],
    "dispute": [
        ("The two nations dispute the border territory.", "两国对边境领土存在争议。"),
        ("They dispute the accuracy of the report.", "他们对报告的准确性有异议。"),
        ("The labor dispute was settled peacefully.", "劳资纠纷得到了和平解决。"),
    ],
    "disseminate": [
        ("The agency disseminates public health information.", "该机构传播公共卫生信息。"),
        ("Social media helps disseminate news quickly.", "社交媒体有助于快速传播新闻。"),
        ("Teachers disseminate knowledge to students.", "教师向学生传播知识。"),
    ],
    "dove": [
        ("A white dove landed on the windowsill.", "一只白鸽落在窗台上。"),
        ("The dove is a symbol of peace.", "鸽子是和平的象征。"),
        ("Children fed the dove in the park.", "孩子们在公园里喂鸽子。"),
    ],
    "drag": [
        ("Don't drag your feet on this decision.", "别在这个决定上拖拉。"),
        ("He had to drag the heavy box upstairs.", "他不得不把沉重的箱子拖上楼。"),
        ("The meeting seemed to drag on forever.", "会议似乎没完没了地拖着。"),
    ],
    "ensure": [
        ("Please ensure that all doors are locked.", "请确保所有门都已锁好。"),
        ("Good planning will ensure success.", "良好的规划将确保成功。"),
        ("The law ensures equal rights for citizens.", "法律保障公民平等权利。"),
    ],
    "especially": [
        ("I love fruit, especially strawberries.", "我喜欢水果，尤其是草莓。"),
        ("Drive carefully, especially in the rain.", "小心驾驶，尤其是在雨中。"),
        ("She is especially talented in music.", "她在音乐方面特别有天赋。"),
    ],
    "expel": [
        ("The school may expel students who cheat.", "学校可能开除作弊的学生。"),
        ("The body expels toxins through the liver.", "身体通过肝脏排出毒素。"),
        ("He was expelled from the club for misconduct.", "他因行为不当被俱乐部除名。"),
    ],
    "fate": [
        ("She accepted her fate calmly.", "她平静地接受了命运。"),
        ("No one can escape fate forever.", "没有人能永远逃脱命运。"),
        ("The fate of the project is still uncertain.", "项目的命运仍不确定。"),
    ],
    "federal": [
        ("Federal law overrides state law in this case.", "在这种情况下联邦法律优先于州法律。"),
        ("The federal government announced new policies.", "联邦政府宣布了新政策。"),
        ("He works for a federal agency.", "他在一家联邦机构工作。"),
    ],
    "generations": [
        ("Stories passed down through generations.", "故事代代相传。"),
        ("Younger generations prefer digital payments.", "年轻一代更喜欢数字支付。"),
        ("The tradition spans many generations.", "这一传统延续了好几代人。"),
    ],
    "grit": [
        ("Success often requires grit and patience.", "成功往往需要毅力和耐心。"),
        ("Sand and grit covered the road.", "沙砾覆盖了路面。"),
        ("Her grit helped her overcome every obstacle.", "她的坚韧帮助她克服了每一个障碍。"),
    ],
    "gritty": [
        ("The film tells a gritty story of urban life.", "这部电影讲述了残酷的城市生活故事。"),
        ("His gritty determination impressed the coach.", "他坚韧不拔的决心打动了教练。"),
        ("The gritty texture of the bread was unusual.", "面包粗粝的口感很特别。"),
    ],
    "gutter": [
        ("Leaves clogged the gutter after the storm.", "暴风雨后落叶堵住了排水沟。"),
        ("Water flowed along the gutter into the drain.", "水沿着檐沟流入下水道。"),
        ("He fixed the broken gutter on the roof.", "他修好了屋顶上破损的檐沟。"),
    ],
    "hippie": [
        ("The hippie movement peaked in the 1960s.", "嬉皮运动在20世纪60年代达到顶峰。"),
        ("She dressed like a hippie at the festival.", "她在音乐节上打扮得像个嬉皮士。"),
        ("Hippie culture promoted peace and love.", "嬉皮文化倡导和平与爱。"),
    ],
    "immortality": [
        ("Ancient poets wrote about immortality.", "古代诗人写过关于永生的诗篇。"),
        ("The hero sought immortality in legend.", "传说中英雄追求长生不老。"),
        ("Art can grant a kind of immortality to creators.", "艺术能给创作者一种不朽。"),
    ],
    "indolence": [
        ("Indolence will not lead to success.", "懒惰不会带来成功。"),
        ("He was criticized for his indolence.", "他因懒散受到批评。"),
        ("The heat encouraged indolence on summer afternoons.", "夏日的炎热让人午后慵懒。"),
    ],
    "insecure": [
        ("She felt insecure about her presentation.", "她对自己的演讲感到没把握。"),
        ("The insecure lock needs to be replaced.", "这把不牢固的锁需要更换。"),
        ("Teenagers often feel insecure about their appearance.", "青少年常对自己的外表感到不自信。"),
    ],
}


def _phrase_example(phrase: str, translation: str) -> dict:
    trans = translation.split("；")[0].split(";")[0].strip()
    if " " in phrase:
        en = f"The article explains how to use {phrase} correctly."
        cn = f"这篇文章解释了如何正确使用 {phrase}（{trans}）。"
    else:
        en = f"Learners should memorize the collocation \"{phrase}\"."
        cn = f"学习者应记住搭配 \"{phrase}\"（{trans}）。"
    return {"en": en, "cn": cn}


def _merge_collocations(word: str, meta: dict, level4_phrases: dict) -> list:
    seen = set()
    merged = []

    for source in (
        meta.get("collocations", []),
        [
            {"phrase": item["phrase"], "translation": item["translation"]}
            for item in level4_phrases.get(word, [])
        ],
    ):
        for item in source:
            phrase = (item.get("phrase") or "").strip()
            if not phrase or phrase in seen:
                continue
            seen.add(phrase)
            translation = item.get("translation") or ""
            merged.append(
                {
                    "phrase": phrase,
                    "translation": translation,
                    "example": _phrase_example(phrase, translation),
                }
            )
    return merged


def _build_synonyms(meta: dict, synonym_meanings: dict) -> list:
    synonyms = []
    for item in meta.get("synonyms", []):
        if isinstance(item, dict):
            word = (item.get("word") or "").strip()
            meaning = (item.get("meaning") or item.get("chinese") or "").strip()
        else:
            word = str(item).strip()
            meaning = synonym_meanings.get(word, "").strip()
        if not word:
            continue
        synonyms.append({"word": word, "meaning": meaning})
    return synonyms


def main() -> None:
    with META_PATH.open(encoding="utf-8") as handle:
        meta_by_word = json.load(handle)
    with SYNONYM_MEANINGS_PATH.open(encoding="utf-8") as handle:
        synonym_meanings = json.load(handle)

    level4_phrases = {}
    if LEVEL4_PATH.exists():
        with LEVEL4_PATH.open(encoding="utf-8") as handle:
            for item in json.load(handle):
                level4_phrases[item["word"]] = item.get("phrases", [])

    with BOOK_PATH.open(encoding="utf-8") as handle:
        book = json.load(handle)

    book["description"] = (
        "用于流程测试：第1关30词 + 第2关10词 | "
        f"{CONTENT_MARKER}"
    )

    missing = []
    for entry in book["words"]:
        word = entry["word"]
        examples = WORD_EXAMPLES.get(word)
        meta = meta_by_word.get(word)
        if not examples or not meta:
            missing.append(word)
            continue

        entry["examples"] = [{"en": en, "cn": cn} for en, cn in examples]
        phonetic = PHONETICS.get(word)
        if phonetic:
            entry["phoneticUk"], entry["phoneticUs"] = phonetic
        entry["synonyms"] = _build_synonyms(meta, synonym_meanings)
        entry["definitions"] = MULTI_POS_DEFINITIONS.get(
            word,
            meta.get("definitions", []),
        )
        entry["englishDefinitions"] = meta.get("englishDefinitions", [])
        entry["collocations"] = _merge_collocations(word, meta, level4_phrases)
        entry["memoryTips"] = meta.get("memoryTips", {})
        entry["root"] = meta.get("root", "")

        if not entry.get("definitionCn") and entry["definitions"]:
            entry["definitionCn"] = entry["definitions"][0]["meaning"]
        if not entry.get("partOfSpeech") and entry["definitions"]:
            entry["partOfSpeech"] = entry["definitions"][0]["partOfSpeech"]

    if missing:
        raise SystemExit(f"Missing metadata for: {missing}")

    with BOOK_PATH.open("w", encoding="utf-8") as handle:
        json.dump(book, handle, ensure_ascii=False, indent=2)

    print(f"Updated {len(book['words'])} words in {BOOK_PATH.name}")


if __name__ == "__main__":
    main()