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
  '気温が変わりやすい季節となってきました。風邪などひかぬようお気を付けください。',
  'では、良いご縁がありますように。',
  '以上で自己紹介を終わります。',
  'さあ申請ボタンをクリッククリック～。'
]

rate_comment = [
  '忙しくてナースコール頻回の病棟でしたが、皆がせっせと働くのでチーム医療は充実してました。向上心もありいい職場でした。バイトなので委員会などで忙しそうにしている常勤の看護師をみるとこのサイトを教えてあげたくなります。',
  'とても素敵な病院です。 皆さん仲良くて、すごくわきあいあいとしています。 患者さんにもとても優しくて働くには最適なところだと思います。急性期病院でなんでも受け入れる方針なので、症例は多くとても勉強になります。 急性期看護が好きな人はICU、救命で働けばとても充実した毎日を送れそうです。暇な時間も多くて将棋ばかりやっています。',
  '雰囲気が良いところもあれば、全体的にピリピリしている所もあります。どっちかと言うと雰囲気が悪いところの方が多い印象です。子供のいるママさんでも働きやすい印象を受けています。病棟ごとに忙しさや人間関係は異なります。',
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
# CSV.foreach("db/csv/host_#{Rails.env}.csv", headers: true) do |row|
CSV.foreach("db/csv/host_min.csv", headers: true) do |row|
  hosts = Host.create(
    name: row['name'],
    email: Faker::Internet.email,
    myid: Faker::Lorem.characters(number: 10),
    phone: row['phone'],
    password: 'llllll',
    address: row['address'],
    # lat: "35.#{rand(100_000..999_999)}".to_f,
    # lng: "139.7#{rand(10_000..99_999)}".to_f,
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
# CSV.foreach("db/csv/user_#{Rails.env}.csv", headers: true) do |row|
CSV.foreach("db/csv/user_min.csv", headers: true) do |row|
  User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    myid: Faker::Lorem.characters(number: 10),
    password: 'llllll',
    address: "#{row['address1']}#{row['address2']}#{row['address3']}",
    # lat: 35.658581,
    # lng: 139.745433,
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

# seedsのtimes ########################################################################################################
%w[user host].each do |me|
  eval("#{me}s_ids.each do |id|
    pre_time = Time.current.beginning_of_day.since(rand(2..7).days) + rand(0..23).hours + [0, 15, 45].sample.minutes
    rand(3..5).times do
      time = #{me == 'user' ? 'Free' : 'Recruitment'}Time.create(
        #{me}_id: id,
        start_time: a = pre_time + rand(3..120).hours,
        finish_time: a + rand(1..17).hours
      )
      pre_time = time.finish_time
    end
  end")
end

##################################################################################################################################

# seedsのskills############################################################################################################
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

# host ###########################################################################################################################
# guest host
guest_host = Host.create(
  name: '東京都立孝之協同病院',
  email: 'takayuki@guest.host',
  address: '東京都新宿区須賀町2-3',
  # lat: 35.658034,
  # lng: 139.701636,
  myid: 'takayuki',
  phone: '029-1234-5678',
  password: 'takayukipass',
  wanted: true,
  profile: "#{first.sample} #{second.sample} #{third.sample} #{fourth.sample} #{fifth.sample}"
)

# other host
other_host = Host.create(
  name: '平成餅麦病院',
  email: Faker::Internet.email,
  address: '東京都足立区谷中2丁目16-7',
  # lat: 35.658581,
  # lng: 139.745433,
  myid: 'mochimugi',
  phone: '029-9876-5432',
  password: 'llllll',
  wanted: true,
  profile: "#{first.sample} #{second.sample} #{third.sample} #{fourth.sample} #{fifth.sample}"
)
##################################################################################################################################

# user ###########################################################################################################################
# guest user
guest_user = User.create(
  name: '山田 孝之',
  email: 'yamada@guest.user',
  myid: 'yamada',
  password: 'yamadapass',
  address: '東京都港区芝公園',
  # lat: 35.689407,
  # lng: 139.700306,
  wanted: true,
  age: 27,
  year: 6,
  profile: "#{user_first.sample} #{user_second.sample} #{user_third.sample}
            #{user_fourth.sample} #{user_fifth.sample} #{user_sixth.sample}"
)

# other user
other_user = User.create(
  name: '松本 人志',
  email: 'hitoshi@matsumoto.com',
  myid: 'matsumoto',
  password: 'llllll',
  address: '東京都杉並区永福',
  # lat: 35.658581,
  # lng: 139.745433,
  wanted: true,
  age: 56,
  year: 30,
  profile: "#{user_first.sample} #{user_second.sample} #{user_third.sample}
            #{user_fourth.sample} #{user_fifth.sample} #{user_sixth.sample}"
)
##################################################################################################################################

# free_times #####################################################################################################################
# guest user
# 2日後の20:00~
guest_user_time_1 = FreeTime.create(
  user_id: guest_user.id,
  start_time: a = Time.current.since(2.days).beginning_of_day + 20.hours,
  finish_time: a + 40.hours
)
# 8日後の8:30~
guest_user_time_2 = FreeTime.create(
  user_id: guest_user.id,
  start_time: a = Time.current.since(8.days).beginning_of_day + 8.hours + 30.minutes,
  finish_time: a + 8.hours + 30.minutes
)

# 12日後の 9:00~
guest_user_time_3 = FreeTime.create(
  user_id: guest_user.id,
  start_time: a = Time.current.since(12.days).beginning_of_day + 9.hours,
  finish_time: a + 9.hours
)
# 17日後の 21:00~
guest_user_time_4 = FreeTime.create(
  user_id: guest_user.id,
  start_time: a = Time.current.since(17.days).beginning_of_day + 21.hours,
  finish_time: a + 15.hours
)
# 20日後の 9:00~
guest_user_time_5 = FreeTime.create(
  user_id: guest_user.id,
  start_time: a = Time.current.since(20.days).beginning_of_day + 9.hours,
  finish_time: a + 34.hours
)
# 23日後の 12:30~
guest_user_time_6 = FreeTime.create(
  user_id: guest_user.id,
  start_time: a = Time.current.since(23.days).beginning_of_day + 12.hours + 30.minutes,
  finish_time: a + 8.hours + 30.minutes
)
# 26日後の 12:30~
guest_user_time_7 = FreeTime.create(
  user_id: guest_user.id,
  start_time: a = Time.current.since(26.days).beginning_of_day + 12.hours + 30.minutes,
  finish_time: a + 21.hours + 30.minutes
)

# other user
# 20日後の 9:00~
other_user_time_1 = FreeTime.create(
  user_id: other_user.id,
  start_time: a = Time.current.since(20.days).beginning_of_day + 7.hours,
  finish_time: a + 12.hours
)
##################################################################################################################################

# guest hostの recruitment_times #################################################################################################

# 6日後の8:30~
guest_host_time_1 = RecruitmentTime.create(
  host_id: guest_host.id,
  start_time: a = Time.current.since(6.days).beginning_of_day + 8.hours + 30.minutes,
  finish_time: a + 9.hours + 30.minutes
)
# 7日後の8:30~
RecruitmentTime.create(
  host_id: guest_host.id,
  start_time: a = Time.current.since(7.days).beginning_of_day + 8.hours + 30.minutes,
  finish_time: a + 9.hours + 30.minutes
)
# 8日後の8:30~
RecruitmentTime.create(
  host_id: guest_host.id,
  start_time: a = Time.current.since(8.days).beginning_of_day + 8.hours + 30.minutes,
  finish_time: a + 9.hours + 30.minutes
)
# 9日後の8:30~
RecruitmentTime.create(
  host_id: guest_host.id,
  start_time: a = Time.current.since(9.days).beginning_of_day + 8.hours + 30.minutes,
  finish_time: a + 9.hours + 30.minutes
)
# 15日後の17:00~
RecruitmentTime.create(
  host_id: guest_host.id,
  start_time: a = Time.current.since(15.days).beginning_of_day + 17.hours,
  finish_time: a + 16.hours
)
# 20日後の9:00~
guest_host_time_2 = RecruitmentTime.create(
  host_id: guest_host.id,
  start_time: a = Time.current.since(20.days).beginning_of_day + 9.hours,
  finish_time: a + 8.hours
)
# 24日後の8:30~
RecruitmentTime.create(
  host_id: guest_host.id,
  start_time: a = Time.current.since(24.days).beginning_of_day + 8.hours + 30.minutes,
  finish_time: a + 12.hours + 30.minutes
)
##################################################################################################################################

# guest userの user_requests #####################################################################################################
UserRequest.create([
                     {
                       user_id: guest_user.id, recruitment_time_id: guest_host_time_1.id,
                       start_time: guest_host_time_1.start_time, finish_time: guest_host_time_1.finish_time
                     },
                     {
                       user_id: guest_user.id, recruitment_time_id: guest_host_time_2.id,
                       start_time: guest_host_time_2.start_time, finish_time: guest_host_time_2.finish_time
                     }
                   ])
##################################################################################################################################

# host_requests ##################################################################################################################
HostRequest.create([
                     # (guest host - guest user)
                     {
                       host_id: guest_host.id, free_time_id: guest_user_time_1.id,
                       start_time: a = guest_user_time_1.start_time + 2.hours, finish_time: a + 10.hours
                     },
                     # (guest host - other user)
                     {
                       host_id: guest_host.id, free_time_id: other_user_time_1.id,
                       start_time: a = other_user_time_1.start_time + 2.hours, finish_time: a + 8.hours
                     },
                     # (other host - guest user)
                     {
                       host_id: other_host.id, free_time_id: guest_user_time_5.id,
                       start_time: a = guest_user_time_5.start_time + 3.hours, finish_time: a + 30.hours
                     }
                   ])
##################################################################################################################################

# rooms, agreement ###############################################################################################################
# (guest user - guest host)
room_1 = Room.create(
  user_id: guest_user.id,
  host_id: guest_host.id,
  start_time: a = Time.current.since(7.days).beginning_of_day + 12.hours,
  finish_time: a + 5.hours,
  state: 'conclusion'
)
Agreement.create(
  room_id: room_1.id,
  user_id: room_1.user_id,
  host_id: room_1.host_id,
  start_time: room_1.start_time,
  finish_time: room_1.finish_time
)

room_3 = Room.create(
  user_id: guest_user.id,
  host_id: guest_host.id,
  start_time: a = Time.current.since(24.days).beginning_of_day + 10.hours,
  finish_time: a + 11.hours,
  state: 'conclusion'
)
Agreement.create(
  room_id: room_3.id,
  user_id: room_3.user_id,
  host_id: room_3.host_id,
  start_time: room_3.start_time,
  finish_time: room_3.finish_time
)

# (guest user - other host)
room_2 = Room.create(
  user_id: guest_user.id,
  host_id: other_host.id,
  start_time: a = Time.current.since(10.days).beginning_of_day + 21.hours,
  finish_time: a + 11.hours + 30.minutes,
  state: 'conclusion'
)
Agreement.create(
  room_id: room_2.id,
  user_id: room_2.user_id,
  host_id: room_2.host_id,
  start_time: room_2.start_time,
  finish_time: room_2.finish_time
)

# (guest host - other user)
room_4 = Room.create(
  user_id: other_user.id,
  host_id: guest_host.id,
  start_time: a = Time.current.since(15.days).beginning_of_day + 17.hours,
  finish_time: a + 5.hours,
  state: 'conclusion'
)
Agreement.create(
  room_id: room_4.id,
  user_id: room_4.user_id,
  host_id: room_4.host_id,
  start_time: room_4.start_time,
  finish_time: room_4.finish_time
)
##################################################################################################################################

# messages #######################################################################################################################
# room_1
HostMessage.create(
  room_id: room_1.id,
  message: 'いきなり申請失礼します。今提示してあります時間帯で勤務いかがでしょうか。',
  created_at: a = Time.current.ago(7.days)
)
UserMessage.create(
  room_id: room_1.id,
  message: 'すみません。少し用事が入ってしまいまして、12時からなら可能なのですが、、、',
  created_at: a + 20.minutes
)
HostMessage.create(
  room_id: room_1.id,
  message: '12時からでもありがたいです。時間を変更しておきましたので契約お願いします。',
  created_at: a + 40.minutes
)
UserMessage.create(
  room_id: room_1.id,
  message: '契約しました。よろしくお願いします！',
  created_at: a + 60.minutes
)

# room_2
UserMessage.create(
  room_id: room_2.id,
  message: 'このあたりの時間で夜勤入れませんか？',
  created_at: a = Time.current.ago(5.days)
)
HostMessage.create(
  room_id: room_2.id,
  message: '忙しくなるので覚悟してよ～。こっちは申請してくれた時間で許可したからね。',
  created_at: a + 30.minutes
)
UserMessage.create(
  room_id: room_2.id,
  message: '忙しいのは嫌いじゃありません。よろしくお願いします。',
  created_at: a + 45.minutes
)

# room_3
UserMessage.create(
  room_id: room_3.id,
  message: 'どうしてもこの日に入りたいんです。',
  created_at: a = Time.current.ago(3.days)
)
HostMessage.create(
  room_id: room_3.id,
  message: 'そんな日もありますね。8時30分から勤務できないですか？',
  created_at: a + 70.minutes
)
UserMessage.create(
  room_id: room_3.id,
  message: '朝は必ず寝坊してしまうので10時以降でお願いします。',
  created_at: a + 100.minutes
)
HostMessage.create(
  room_id: room_3.id,
  message: '分かりました。では10時でいいですね？',
  created_at: a + 120.minutes
)
UserMessage.create(
  room_id: room_3.id,
  message: 'お願いします。',
  created_at: a + 135.minutes
)

# room4
UserMessage.create(
  room_id: room_4.id,
  message: '夜勤はできないですけど22時くらいまでとかでできませんか？',
  created_at: a = Time.current.ago(4.days)
)
HostMessage.create(
  room_id: room_4.id,
  message: 'まぁしょうがないからいいかー。',
  created_at: a + 155.minutes
)
UserMessage.create(
  room_id: room_4.id,
  message: 'やったー',
  created_at: a + 200.minutes
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

# guest host rates  ##############################################################################################################
# 2日前の8:00~17:00
Room.new(
  user_id: guest_user.id,
  host_id: guest_host.id,
  start_time: a = Time.current.ago(2.days).beginning_of_day + 8.hours,
  finish_time: a + 9.hours,
  state: 'conclusion',
  closed: 'both'
).save(validate: false)

room_2_days_ago = Room.last

Agreement.new(
  user_id: room_2_days_ago.user_id,
  host_id: room_2_days_ago.host_id,
  start_time: room_2_days_ago.start_time,
  finish_time: room_2_days_ago.finish_time,
  state: 'finished',
  room_id: room_2_days_ago.id
).save(validate: false)

agreement_2_days_ago = Agreement.last

rate_2_days_ago = Rate.create(
  star: rand(1..5),
  comment: rate_comment.sample,
  agreement_id: agreement_2_days_ago.id
)

# 10日前の12:00~21:00
Room.new(
  user_id: other_user.id,
  host_id: guest_host.id,
  start_time: a = Time.current.ago(10.days).beginning_of_day + 12.hours,
  finish_time: a + 9.hours,
  state: 'conclusion',
  closed: 'both'
).save(validate: false)

room_10_days_ago = Room.last

Agreement.new(
  user_id: room_10_days_ago.user_id,
  host_id: room_10_days_ago.host_id,
  start_time: room_10_days_ago.start_time,
  finish_time: room_10_days_ago.finish_time,
  state: 'finished',
  room_id: room_10_days_ago.id
).save(validate: false)

agreement_10_days_ago = Agreement.last

rate_10_days_ago = Rate.create(
  star: rand(1..5),
  comment: rate_comment.sample,
  agreement_id: agreement_10_days_ago.id
)

# 15日前の18:00~21:00
Room.new(
  user_id: users_ids.sample,
  host_id: guest_host.id,
  start_time: a = Time.current.ago(15.days).beginning_of_day + 18.hours,
  finish_time: a + 3.hours,
  state: 'conclusion',
  closed: 'both'
).save(validate: false)

room_15_days_ago = Room.last

Agreement.new(
  user_id: room_15_days_ago.user_id,
  host_id: room_15_days_ago.host_id,
  start_time: room_15_days_ago.start_time,
  finish_time: room_15_days_ago.finish_time,
  state: 'finished',
  room_id: room_15_days_ago.id
).save(validate: false)

agreement_15_days_ago = Agreement.last

rate_15_days_ago = Rate.create(
  star: rand(1..5),
  comment: rate_comment.sample,
  agreement_id: agreement_15_days_ago.id
)
##################################################################################################################################

# host seeds の rates ############################################################################################################
hosts_ids.each do |id|
  rand(1..5).times do
   Room.new(
      user_id: users_ids.sample,
      host_id: id,
      start_time: a = Time.current.ago(rand(0..100)).beginning_of_day,
      finish_time: a + 5.hours,
      state: 'conclusion',
      closed: 'both'
    ).save(validate: false)

    room = Room.last

    Agreement.new(
      user_id: room.user_id,
      host_id: room.host_id,
      start_time: room.start_time,
      finish_time: room.finish_time,
      state: 'finished',
      room_id: room.id
    ).save(validate: false)

    agreement = Agreement.last

    rate = Rate.create(
      star: rand(1..5),
      comment: rate_comment.sample,
      agreement_id: agreement.id
    )
  end
end
##################################################################################################################################

# during のagreement #############################################################################################################
# guest_user - guest_host
Room.new(
  user_id: guest_user.id,
  host_id: guest_host.id,
  start_time: Time.current - 3.hours,
  finish_time: Time.current + 5.hours,
  state: 'conclusion',
  closed: 'na'
).save(validate: false)

room = Room.last

Agreement.new(
  user_id: guest_user.id,
  host_id: guest_host.id,
  start_time: room.start_time,
  finish_time: room.finish_time,
  state: 'during',
  room_id: room.id
).save(validate: false)

# guest_host - seed_user
Room.new(
  user_id: users_ids.sample,
  host_id: guest_host.id,
  start_time: Time.current - 4.hours,
  finish_time: Time.current + 7.hours,
  state: 'conclusion',
  closed: 'na'
).save(validate: false)

room = Room.last

Agreement.new(
  user_id: room.user_id,
  host_id: guest_host.id,
  start_time: room.start_time,
  finish_time: room.finish_time,
  state: 'during',
  room_id: room.id
).save(validate: false)
##################################################################################################################################