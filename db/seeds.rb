# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Event.create([
  { name: '開幕！アイドルイントロダクション',
    started_at: '2013-03-05 17:00:00 +0900',
    ended_at: '2013-03-11 16:59:59 +0900'
  },
  { name: '開演！ロケットスタートライブ!',
    started_at: '2013-03-14 17:00:00 +0900',
    ended_at: '2013-03-25 16:59:59 +0900'
  },
  { name: '輝け！春の野外音楽フェスティバル',
    started_at: '2013-03-28 17:00:00 +0900',
    ended_at: '2013-04-08 16:59:59 +0900'
  },
  { name: 'ようこそ！アイドル学園天国',
    started_at: '2013-04-11 17:00:00 +0900',
    ended_at: '2013-04-22 16:59:59 +0900'
  },
  { name: '風雲！アイドルキャッスル！',
    started_at: '2013-04-25 17:00:00 +0900',
    ended_at: '2013-05-07 16:59:59 +0900'
  },
  { name: '大爆走！765レーサーグランプリ',
    started_at: '2013-05-09 17:00:00 +0900',
    ended_at: '2013-05-20 16:59:59 +0900'
  },
  { name: '輝け！アイドルライブバトルアリーナ',
    started_at: '2013-05-23 17:00:00 +0900',
    ended_at: '2013-05-27 16:59:59 +0900'
  },
  { name: '大合戦！戦国アイドル活劇',
    started_at: '2013-05-29 17:00:00 +0900',
    ended_at: '2013-06-10 16:59:59 +0900'
  },
  { name: '激闘！NAMCOアイドルサッカーフェス2013',
    started_at: '2013-06-13 17:00:00 +0900',
    ended_at: '2013-06-24 16:59:59 +0900'
  },
  { name: '夏直前！アイドル水上大運動会！',
    started_at: '2013-06-27 17:00:00 +0900',
    ended_at: '2013-07-08 16:59:59 +0900'
  },
  { name: '納涼！アイドル夏祭り',
    started_at: '2013-07-11 17:00:00 +0900',
    ended_at: '2013-07-22 16:59:59 +0900'
  },
  { name: '白熱！アイドルユニットトーナメント',
    started_at: '2013-07-25 17:00:00 +0900',
    ended_at: '2013-07-30 16:59:59 +0900'
  },
  { name: '熱唱！真夏のサマーライブフェス',
    started_at: '2013-08-02 17:00:00 +0900',
    ended_at: '2013-08-12 16:59:59 +0900'
  },
  { name: '大激闘！765プロ野球',
    started_at: '2013-08-15 17:00:00 +0900',
    ended_at: '2013-08-26 16:59:59 +0900'
  },
  { name: '恐怖！アイドルドキドキ肝だめし',
    started_at: '2013-08-29 14:00:00 +0900',
    ended_at: '2013-09-09 16:59:59 +0900'
  },
  { name: '遊べ！アイドルゲームフェス',
    started_at: '2013-09-12 17:00:00 +0900',
    ended_at: '2013-09-24 16:59:59 +0900'
  },
  { name: '大航海！アイドルパイレーツ',
    started_at: '2013-09-26 14:00:00 +0900',
    ended_at: '2013-10-07 16:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ',
    event_type: 'imc_event',
    started_at: '2013-10-10 17:00:00 +0900',
    ended_at: '2013-10-15 23:59:59 +0900'
  },
  { name: '開催！アイドル学園文化祭',
    event_type: 'choco_event',
    started_at: '2013-10-17 17:00:00 +0900',
    ended_at: '2013-10-28 16:59:59 +0900'
  },
  { name: '狂騒！ハロウィンフェスタ',
    event_type: 'raid_event',
    started_at: '2013-10-30 14:00:00 +0900',
    ended_at: '2013-11-12 16:59:59 +0900'
  },
  { name: 'GO!GO! アイドルゴルフ大会',
    started_at: '2013-11-14 17:00:00 +0900',
    ended_at: '2013-11-25 16:59:59 +0900'
  },
  { name: '極めよ！アイドル道',
    event_type: 'lesson_event',
    started_at: '2013-11-28 17:00:00 +0900',
    ended_at: '2013-12-09 16:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ2',
    event_type: 'imc_event',
    started_at: '2013-12-12 17:00:00 +0900',
    ended_at: '2013-12-16 23:59:59 +0900'
  },
  { name: '聖夜の奇跡！アイドルクリスマスTV',
    event_type: 'lesson_event',
    started_at: '2013-12-17 17:00:00 +0900',
    ended_at: '2013-12-25 16:59:59 +0900'
  },
  { name: '年またぎ！アイドル紅白歌祭り',
    event_type: 'raid_event',
    started_at: '2013-12-26 17:00:00 +0900',
    ended_at: '2014-01-06 16:59:59 +0900'
  },
  { name: '招福！アイドル干支レース',
    event_type: 'raid_event',
    started_at: '2014-01-09 17:00:00 +0900',
    ended_at: '2014-01-21 16:59:59 +0900'
  },
  { name: '出演！アイドルスペースウォーズ',
    event_type: 'lesson_event',
    started_at: '2014-01-23 17:00:00 +0900',
    ended_at: '2014-02-04 16:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ3',
    event_type: 'imc_event',
    started_at: '2014-02-06 17:00:00 +0900',
    ended_at: '2014-02-10 23:59:59 +0900'
  },
  { name: '甘いご奉仕！バレンタインキャラバン',
    event_type: 'choco_event',
    started_at: '2014-02-13 17:00:00 +0900',
    ended_at: '2014-02-24 16:59:59 +0900'
  },
  { name: '出撃！アイドルヒーローズ',
    event_type: 'raid_event',
    started_at: '2014-02-27 17:00:00 +0900',
    ended_at: '2014-03-10 16:59:59 +0900'
  },
  { name: '大合奏！アイドルシンフォニー',
    event_type: 'lesson_event',
    started_at: '2014-03-13 17:00:00 +0900',
    ended_at: '2014-03-24 16:59:59 +0900'
  },
  { name: '集まれ！アイドルモンスターズ',
    event_type: 'raid_event',
    started_at: '2014-03-27 17:00:00 +0900',
    ended_at: '2014-04-02 16:59:59 +0900'
  },
  { name: '【復活】ようこそ！アイドル学園天国',
    event_type: 'choco_event',
    started_at: '2014-04-04 17:00:00 +0900',
    ended_at: '2014-04-08 16:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ4',
    event_type: 'imc_event',
    started_at: '2014-04-10 17:00:00 +0900',
    ended_at: '2014-04-14 23:59:59 +0900'
  },
  { name: '開幕！春のサイクリングレース',
    event_type: 'choco_event',
    started_at: '2014-04-17 17:00:00 +0900',
    ended_at: '2014-04-28 16:59:59 +0900'
  },
  { name: '逆襲！グレートアイドルキャッスル',
    event_type: 'raid_event',
    started_at: '2014-04-30 17:00:00 +0900',
    ended_at: '2014-05-07 16:59:59 +0900'
  },
  { name: '復活！NAMCOアイドルサッカーフェス2013',
    event_type: 'choco_event',
    started_at: '2014-05-09 17:00:00 +0900',
    ended_at: '2014-05-13 16:59:59 +0900'
  },
  { name: '夢いっぱい！メルヘンアイドル物語',
    event_type: 'lesson_event',
    started_at: '2014-05-15 17:00:00 +0900',
    ended_at: '2014-05-26 16:59:59 +0900'
  },
  { name: '大戦乱！アイドル三国志',
    event_type: 'raid_event',
    started_at: '2014-05-29 17:00:00 +0900',
    ended_at: '2014-06-04 16:59:59 +0900'
  },
  { name: '集え！NAMCOアイドルサッカーフェス2014',
    event_type: 'choco_event',
    started_at: '2014-06-06 17:00:00 +0900',
    ended_at: '2014-06-17 16:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ5',
    event_type: 'imc_event',
    started_at: '2014-06-19 17:00:00 +0900',
    ended_at: '2014-06-23 23:59:59 +0900'
  },
  { name: '進軍！アイドルフォース',
    event_type: 'raid_event',
    started_at: '2014-06-25 17:00:00 +0900',
    ended_at: '2014-07-02 16:59:59 +0900'
  },
  { name: '極限！サバイバルアイランド',
    event_type: 'lesson_event',
    started_at: '2014-07-04 17:00:00 +0900',
    ended_at: '2014-07-15 16:59:59 +0900'
  },
  { name: '決行！プラチナスターライブ1ST',
    event_type: 'psl_event',
    started_at: '2014-07-17 17:00:00 +0900',
    ended_at: '2014-07-24 16:59:59 +0900'
  },
  { name: '決行！プラチナスターライブ1STアンコール',
    event_type: 'psl_event',
    started_at: '2014-07-25 17:00:00 +0900',
    ended_at: '2014-07-28 16:59:59 +0900'
  },
  { name: 'HAPPY★HAPPY★PERFORM@NCE',
    event_type: 'hhp_event',
    started_at: '2014-07-30 17:00:00 +0900',
    ended_at: '2014-08-06 16:59:59 +0900'
  },
  { name: '納涼！アイドル夏祭りin港町',
    event_type: 'choco_event',
    started_at: '2014-08-08 17:00:00 +0900',
    ended_at: '2014-08-19 16:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ6',
    event_type: 'imc_event',
    started_at: '2014-08-21 17:00:00 +0900',
    ended_at: '2014-08-25 23:59:59 +0900'
  },
  { name: '戦慄！アイドル肝だめし病棟',
    event_type: 'raid_event',
    started_at: '2014-08-27 17:00:00 +0900',
    ended_at: '2014-09-03 16:59:59 +0900'
  },
  { name: '夢いっぱい！アイドルゲームフェス2014',
    event_type: 'lesson_event',
    started_at: '2014-09-05 17:00:00 +0900',
    ended_at: '2014-09-16 16:59:59 +0900'
  },
  { name: '結実！プラチナスターライブ2ND',
    event_type: 'psl_event',
    started_at: '2014-09-17 17:00:00 +0900',
    ended_at: '2014-09-28 23:59:59 +0900'
  },
  { name: '決選！学園ミスコンサバイバル',
    event_type: 'raid_event',
    started_at: '2014-09-30 17:00:00 +0900',
    ended_at: '2014-10-08 16:59:59 +0900'
  },
  { name: '昂れ！アイドルファイト',
    event_type: 'choco_event',
    started_at: '2014-10-10 17:00:00 +0900',
    ended_at: '2014-10-20 16:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ7',
    event_type: 'imc_event',
    started_at: '2014-10-22 17:00:00 +0900',
    ended_at: '2014-10-26 23:59:59 +0900'
  },
  { name: '激動！アイドル警察24時',
    event_type: 'raid_event',
    started_at: '2014-10-28 17:00:00 +0900',
    ended_at: '2014-11-05 16:59:59 +0900'
  },
  { name: '進出！アジアンライブツアー',
    event_type: 'lesson_event',
    started_at: '2014-11-07 17:00:00 +0900',
    ended_at: '2014-11-16 23:59:59 +0900'
  },
  { name: '熱烈！プラチナスターライブ3RD',
    event_type: 'psl_event',
    started_at: '2014-11-17 17:00:00 +0900',
    ended_at: '2014-11-26 23:59:59 +0900'
  },
  { name: '祝祭！クリスマスフェスタ',
    event_type: 'choco_event',
    started_at: '2014-11-28 17:00:00 +0900',
    ended_at: '2014-12-08 16:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ8',
    event_type: 'imc_event',
    started_at: '2014-12-10 17:00:00 +0900',
    ended_at: '2014-12-14 23:59:59 +0900'
  },
  { name: '神vs魔！ホーリーナイトラウンド',
    event_type: 'raid_event',
    started_at: '2014-12-16 17:00:00 +0900',
    ended_at: '2014-12-24 23:59:59 +0900'
  },
  { name: '年越し！アイドル美食グランプリ',
    event_type: 'lesson_event',
    started_at: '2014-12-26 17:00:00 +0900',
    ended_at: '2015-01-05 23:59:59 +0900'
  },
  { name: '招福！アイドル干支マラソン',
    event_type: 'raid_event',
    started_at: '2015-01-07 17:00:00 +0900',
    ended_at: '2015-01-14 23:59:59 +0900'
  },
  { name: '大成！プラチナスターライブ4TH',
    event_type: 'psl_event',
    started_at: '2015-01-16 17:00:00 +0900',
    ended_at: '2015-01-27 23:59:59 +0900'
  },
  { name: '鬼だらけ！アイドル節分パニック',
    event_type: 'raid_event',
    started_at: '2015-01-29 17:00:00 +0900',
    ended_at: '2015-02-08 23:59:59 +0900'
  },
  { name: '甘ふわ♪ショコラハウス',
    event_type: 'choco_event',
    started_at: '2015-02-10 17:00:00 +0900',
    ended_at: '2015-02-18 23:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ9',
    event_type: 'imc_event',
    started_at: '2015-02-20 17:00:00 +0900',
    ended_at: '2015-02-24 23:59:59 +0900'
  },
  { name: '繚乱！紅梅白梅ファッションショー',
    event_type: 'raid_event',
    started_at: '2015-02-27 17:00:00 +0900',
    ended_at: '2015-03-08 23:59:59 +0900'
  },
  { name: '熱踏！アイドルカーニバル',
    event_type: 'lesson_event',
    started_at: '2015-03-10 17:00:00 +0900',
    ended_at: '2015-03-17 23:59:59 +0900'
  },
  { name: '収束！プラチナスターライブ FINAL',
    event_type: 'psl_event',
    started_at: '2015-03-19 17:00:00 +0900',
    ended_at: '2015-03-29 23:59:59 +0900'
  },
  { name: '駆けろ！アイドルバスケリーグ',
    event_type: 'raid_event',
    started_at: '2015-04-07 17:00:00 +0900',
    ended_at: '2015-04-19 23:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ10',
    event_type: 'imc_event',
    started_at: '2015-04-22 17:00:00 +0900',
    ended_at: '2015-04-26 23:59:59 +0900'
  },
  { name: '【復刻】風雲！アイドルキャッスル！',
    event_type: 'raid_event',
    started_at: '2015-04-28 17:00:00 +0900',
    ended_at: '2015-05-06 23:59:59 +0900'
  },
  { name: '特番！生っすか！？サンデー×50',
    event_type: 'lesson_event',
    started_at: '2015-05-08 17:00:00 +0900',
    ended_at: '2015-05-17 23:59:59 +0900'
  },
  { name: '絢爛！ゴールデンキャッスルライブ',
    event_type: 'caravan_event',
    started_at: '2015-05-19 17:00:00 +0900',
    ended_at: '2015-05-27 23:59:59 +0900'
  },
  { name: 'ENJOY H@RMONY!!',
    event_type: 'hhp_event',
    started_at: '2015-05-29 17:00:00 +0900',
    ended_at: '2015-06-07 23:59:59 +0900'
  },
  { name: '夏到来！アイドル水上大運動会2015',
    event_type: 'choco_event',
    started_at: '2015-06-09 17:00:00 +0900',
    ended_at: '2015-06-17 23:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ11',
    event_type: 'imc_event',
    started_at: '2015-06-19 17:00:00 +0900',
    ended_at: '2015-06-23 23:59:59 +0900'
  },
  { name: '【復刻】大合戦！戦国アイドル活劇',
    event_type: 'raid_event',
    started_at: '2015-06-25 17:00:00 +0900',
    ended_at: '2015-07-05 23:59:59 +0900'
  },
  { name: 'キラキラ★アイドル七夕祭り',
    event_type: 'lesson_event',
    started_at: '2015-07-07 17:00:00 +0900',
    ended_at: '2015-07-15 23:59:59 +0900'
  },
  { name: '壮麗！ブルーオーシャンライブ',
    event_type: 'caravan_event',
    started_at: '2015-07-17 17:00:00 +0900',
    ended_at: '2015-07-26 23:59:59 +0900'
  },
  { name: 'はじける汗！アイドルビーチバレー大会',
    event_type: 'raid_event',
    started_at: '2015-07-28 17:00:00 +0900',
    ended_at: '2015-08-05 23:59:59 +0900'
  },
  { name: '怨霊！アイドル肝試しホテル',
    event_type: 'choco_event',
    started_at: '2015-08-07 17:00:00 +0900',
    ended_at: '2015-08-17 23:59:59 +0900'
  },
  { name: 'アイドルマスターズカップ12',
    event_type: 'imc_event',
    started_at: '2015-08-19 17:00:00 +0900',
    ended_at: '2015-08-23 23:59:59 +0900'
  }
])
