# frozen_string_literal: true

Faker::Config.locale = 'ja'
require 'csv'

# Skill
Skill.create([
               # ,{name: ''}
               # common
               { name: '生活指導' }, { name: '輸血管理' }, { name: 'シリンジポンプの取り扱い' }, { name: '採血' },
               # 手術室系
               { name: '手術室看護' }, { name: '器械出し' }, { name: '外回り' }, { name: '麻酔介助' },
               # 消化器系
               { name: 'ストーマの取り扱い' }, { name: '消化器手術後のオリエンテーション' }, { name: '腹水穿刺' }, { name: '内視鏡検査介助' }, { name: '糖尿病患者への退院指導' },
               # 小児系
               { name: '小児看護' }, { name: '小児のプレパレーション' }, { name: '小児家族に対する援助' }, { name: '小児への与薬' }, { name: '小児へのギプス固定' },
               # 循環器系
               { name: '心電図の判読' }, { name: 'ホルター心電図検査の介助' }, { name: '心臓カテーテル検査の介助' }, { name: '運動負荷心電図検査の介助' }, { name: 'Aラインからの採血' },
               { name: '気管切開時の介助' }, { name: '胸腔ドレナージの介助' }, { name: 'PCPS患者のケア' }, { name: 'カテーテルアブレーションの基礎知識' }, { name: '循環器手術後のオリエンテーション' },

               # ICU系
               { name: '人工呼吸器の管理' }, { name: '人工呼吸器の挿入、抜去時介助' }, { name: 'ペースメーカー導入、抜去時介助' }, { name: '一時的ペースメーカの固定・接続・設定' },
               { name: 'BLS' }, { name: 'ICLS' }, { name: 'ACLS' }, { name: 'PALS' }, { name: '創傷部留置ドレーンの管理' }, { name: '早期離床' }

             ])

# Host

# それぞれ60字まで
# 60文字サンプル
# 時にはつらいこともあります。そのつらさを乗り越え、やめられない魅力と楽しさが看護にあることを実感できたらと考えています。

# 11まで 名詞
location = %w[東京都北部 東京都東部 東京都南部 東京都西部 暖かいところ 徒歩では来れないところ]
# 12まで 名詞
hospital_type = %w[救急基幹病院 特定機能病院 地域医療支援病院 大病院 臨床研究中核病院 ご老人専門病院]
# 11まで 名詞
hospital_provided = ['セイフティネット系医療', '高度循環器医療', '質の高い看護、医療', '安心安全の医療', '完治確実の医療']
# 7まで 名詞
motto = %w[患者さんの幸せ 地域の幸せ 職員の幸せ 患者の笑顔 生きる幸せ 看護の本質 永遠の笑顔 長寿 永遠の命 永遠の愛]
# 10まで 形容詞
explanation_of_now = %w[少子高齢化が加速する コロナが蔓延する 地域格差が広がる 戦後最悪の経済成長の]
# 16まで 副詞
ways_to_help_you_grow = %w[看護師の成長に寄り添い 共に手を取り合いながら たまには息抜きしながら 声援を送りながら]
# 8まで 名詞
next_step = %w[キャリアデザイン キャリアアップ 次の免許取得 ラダーの活用]
# 10まで complex
happens_sometimes = ['つらいこともあります', 'つらいことも...', '不運の事態もあるけど', '投げ出したいことも', '山あり谷あり']

first = [
  "当院は、#{location.sample}に位置し、日本を代表する#{hospital_type.sample}です。",
  "当院は、#{hospital_provided.sample}を提供しており、また一般医療にも重点をおいて、地域医療にも積極的に取り組んでいます。",
  'このページをご覧になられているという事は少しでも当院の事が気になったということでしょうか。'

]
second = [
  '一般急性期から回復期、訪問看護ステーションを有し、隣接する千葉県北南部からも多く利用いただいています。',
  "当院は、#{ways_to_help_you_grow.sample}#{next_step.sample}できるようにサポートするシステムがあります。"
]
third = [
  "#{explanation_of_now.sample}いま、患者さんの生活の中に病院があり、病院の機能は役割を持っています。"
]
fourth = [
  "地域完結型を推進する私たちは、病院理念にある「#{motto.sample}」「#{motto.sample}」「#{motto.sample}」を念頭に置き、院内、または地域の中では多職種で連携し、チーム医療を実践しています。"
]
fifth = [
  "看護部は、#{hospital_provided.sample}を提供するために#{next_step.sample}をしています。では次は病棟でお会いしましょう。",
  "時には#{happens_sometimes.sample}。そのつらさを乗り越え、やめられない魅力と楽しさが看護にあることを実感できたらと考えています。",
  "常に#{hospital_provided.sample}が提供できる職場で、皆さんが働きつづけられるように、支えていきたいと思っています。"
]

CSV.foreach("db/csv/host_#{Rails.env}.csv", headers: true) do |row|
  Host.create(
    name: row['name'],
    email: Faker::Internet.email,
    myid: Faker::Lorem.characters(number: 10),
    password: 'llllll',
    address: row['address'],
    wanted: [true, false].sample,
    profile: "#{first.sample} #{second.sample} #{third.sample} #{fourth.sample} #{fifth.sample}"
  )
end
