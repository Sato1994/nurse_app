# frozen_string_literal: true

Faker::Config.locale = 'ja'
require 'csv'

# randomなprofile ################################################################################################################
# それぞれ60字まで
# 11まで 名詞
location = %w[東京都北部 東京都東部 東京都南部 東京都西部 暖かいところ 徒歩では来れないところ]
# 12まで 名詞
hospital_type = %w[救急基幹病院 特定機能病院 地域医療支援病院 大病院 臨床研究中核病院 ご老人専門病院]
# 11まで 名詞
hospital_provided = %w[セイフティネット系医療 高度循環器医療 質の高い看護、医療 安心安全の医療 完治確実の医療]
# 7まで 名詞
motto = %w[患者さんの幸せ 地域の幸せ 職員の幸せ 患者の笑顔 生きる幸せ 看護の本質 永遠の笑顔 長寿 永遠の命 永遠の愛]
# 10まで 形容詞
explanation_of_now = %w[少子高齢化が加速する コロナが蔓延する 地域格差が広がる 戦後最悪の経済成長の]
# 16まで 副詞
ways_to_help_you_grow = %w[看護師の成長に寄り添い 共に手を取り合いながら たまには息抜きしながら 声援を送りながら]
# 8まで 名詞
next_step = %w[キャリアデザイン キャリアアップ 次の免許取得 ラダーの活用]
# 10まで complex
happens_sometimes = %w[つらいこともあります つらいことも... 不運の事態もあるけど 投げ出したいことも 山あり谷あり]

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
  "地域完結型を推進する私たちは、病院理念にある「#{motto.sample}」「#{motto.sample}」「#{motto.sample}」を念頭に置き、
   院内、または地域の中では多職種で連携し、チーム医療を実践しています。"
]
fifth = [
  "看護部は、#{hospital_provided.sample}を提供するために#{next_step.sample}をしています。では次は病棟でお会いしましょう。",
  "時には#{happens_sometimes.sample}。そのつらさを乗り越え、
   やめられない魅力と楽しさが看護にあることを実感できたらと考えています。",
  "常に#{hospital_provided.sample}が提供できる職場で、皆さんが働きつづけられるように、支えていきたいと思っています。"
]

# user
# 300まで
# ひとつ50まで
user_first = [
  '最近は天気が変わりやすいですね。',
  'いつもお世話になっております',
  'こんにちは。',
  '自己紹介をさせて頂きます。'
]
user_second = [
  '私は今まで消化器外科病棟で勤務しており、主に周手術期の看護を学んできました。',
  '私は今まで様々な患者に出会い看護感を養ってきたので、個別性のある看護を提供できると自負しています。',
  '経験という経験はないのですが、'

]

user_third = [
  'この度は前からの夢でもありました小児科病棟で看護ができる職場を探そうと思っております。',
  '今まで培ってきた指先の感覚を武器に、これからも良い看護をしていきたいと思っています。'
]

user_fourth = [
  '登録してある募集時間外でももしかしたら対応可能なので、一度申請を送ってみて頂けると嬉しいです。',
  '今年は休みは入れずにバシバシ働くつもりでいるので募集期間が登録されていれば申請を送ってください。'

]

user_fifth = [
  '交通機関を使用して30分以内の勤務先を希望しています。',
  '気に入った病院があればリピートしてしまうかもしれません。',
  '絶対に医療事故は起こさないという自信があります。'
]

user_sixth = [
  '気温が変わりやすい季節となってきました。風邪などひかぬようご自愛くださいませ。',
  'では、良いご縁がありますように。',
  '以上で自己紹介を終わります。',
  'さあ申請ボタンをクリッククリック～。'
]
##################################################################################################################################

# skills #########################################################################################################################
Skill.create([
               # common
               { name: '生活指導' }, { name: '輸血管理' }, { name: 'シリンジポンプの取り扱い' }, { name: '採血' },
               # 手術室系
               { name: '手術室看護' }, { name: '器械出し' }, { name: '外回り' }, { name: '麻酔介助' },
               # 消化器系
               { name: 'ストーマの取り扱い' }, { name: '消化器手術後のオリエンテーション' }, { name: '腹水穿刺' },
               { name: '内視鏡検査介助' }, { name: '糖尿病患者への退院指導' },
               # 小児系
               { name: '小児看護' }, { name: '小児のプレパレーション' }, { name: '小児家族に対する援助' },
               { name: '小児への与薬' }, { name: '小児へのギプス固定' },
               # 循環器系
               { name: '心電図の判読' }, { name: 'ホルター心電図検査の介助' }, { name: '心臓カテーテル検査の介助' },
               { name: '運動負荷心電図検査の介助' }, { name: 'Aラインからの採血' }, { name: '気管切開時の介助' },
               { name: '胸腔ドレナージの介助' }, { name: 'PCPS患者のケア' }, { name: 'カテーテルアブレーションの基礎知識' },
               { name: '循環器手術後のオリエンテーション' },
               # ICU系
               { name: '人工呼吸器の管理' }, { name: '人工呼吸器の挿入、抜去時介助' }, { name: '早期離床' }, { name: 'BLS' },
               { name: 'ペースメーカー導入、抜去時介助' }, { name: '一時的ペースメーカの固定・接続・設定' },
               { name: 'ICLS' }, { name: 'ACLS' }, { name: 'PALS' }, { name: '創傷部留置ドレーンの管理' }
             ])
skills_ids = []
Skill.all.each do |skill|
  skills_ids << skill.id
end
##################################################################################################################################

# hosts ##########################################################################################################################
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
hosts_ids = []
Host.all.each do |host|
  hosts_ids << host.id
end
##################################################################################################################################

# users ##########################################################################################################################
CSV.foreach("db/csv/user_#{Rails.env}.csv", headers: true) do |row|
  User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    myid: Faker::Lorem.characters(number: 10),
    password: 'llllll',
    address: "#{row['address1']}#{row['address2']}#{row['address3']}",
    wanted: [true, false].sample,
    sex: [true, false].sample,
    age: rand(20..60),
    year: rand(0..39),
    profile: "#{user_first.sample} #{user_second.sample} #{user_third.sample} #{user_fourth.sample}
              #{user_fifth.sample} #{user_sixth.sample}"
  )
end
users_ids = []
User.all.each do |user|
  users_ids << user.id
end
##################################################################################################################################

# users, hostsのskills############################################################################################################
%w[user host].each do |me|
  eval("#{me}s_ids.each do |#{me}_id|
    copy_array = skills_ids.dup
    rand(1..5).times do
      #{me}_skill = #{me == 'user' ? 'User' : 'Host'}Skill.create(
        #{me}_id: #{me}_id,
        skill_id: copy_array.sample
      )
      copy_array.delete(#{me}_skill.skill_id)
    end
  end")
end
##################################################################################################################################

# gest host ######################################################################################################################
guest_host = Host.create(
  name: '東京都立孝之協同病院',
  email: 'takayuki@guest.host',
  address: '東京都新宿区須賀町2-3',
  myid: 'takayuki',
  password: 'takayukipass',
  wanted: true,
  profile: "#{first.sample} #{second.sample} #{third.sample} #{fourth.sample} #{fifth.sample}"
)
##################################################################################################################################

# gest user ######################################################################################################################
guest_user = User.create(
  name: '山田 孝之',
  email: 'yamada@guest.user',
  myid: 'yamada',
  password: 'yamadapass',
  address: '東京都港区芝公園',
  wanted: true,
  age: 27,
  year: 6,
  profile: "#{user_first.sample} #{user_second.sample} #{user_third.sample} #{user_fourth.sample}
  #{user_fifth.sample} #{user_sixth.sample}"
)
##################################################################################################################################

# guest userのfree_times #########################################################################################################
FreeTime.create(
  user_id: guest_user.id,
  start_time: 24.hours.from_now,
  finish_time: 32.hours.from_now
)
##################################################################################################################################

# guest hostの recruitment_times #################################################################################################
RecruitmentTime.create(
  host_id: guest_host.id,
  start_time: 24.hours.from_now,
  finish_time: 40.hours.from_now
)
##################################################################################################################################

# guest user, guest host の skills ###############################################################################################
%w[user host].each do |me|
  copy_array = skills_ids.dup
  3.times do
    eval("#{me}_skill = #{me == 'user' ? 'User' : 'Host'}Skill.create(
      #{me}_id: guest_#{me}.id,
      skill_id: copy_array.sample
    )
    copy_array.delete(#{me}_skill.skill_id)")
  end
end
##################################################################################################################################
