# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 管理者ログイン用（email/pass）
Admin.create!(
  email: 'admin@gmail.com',
  password: '123456'
  )

# ジャンル追加
Genre.create!(
    [
      {
        name: '水族館'
      },
      {
        name: 'おすすめ順路'
      },
      {
        name: 'おすすめの時間'
      },
      {
        name: 'おすすめスポット'
      },
      {
        name: '海洋生物'
      },
      {
        name: 'グッズ'
      },
      {
        name: 'お魚'
      },
      {
        name: 'シャチ'
      },
      {
        name: 'イルカ'
      },
      {
        name: 'ペンギン'
      },
      {
        name: 'チンアナゴ'
      },
      {
        name: 'ラッコ'
      },
    ]
  )