# DB設計

## Usersテーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| uid                | string |                           |
| nickname           | string | null: false               |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |
| tokens             | string | null: false               |
| provider           | string | null: false               |

### Association
- has_many :rooms
- has_many :messages


## Roomsテーブル

| Column              | Type       | Options                        |
| ------------------- | ---------- | ------------------------------ |
| name                | string     | null: false                    |
| password_digest     | string     |                                |
| user                | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- has_many   :agendas


## Agendasテーブル

| Column              | Type       | Options                        |
| ------------------- | ---------- | ------------------------------ |
| name                | string     | null: false                    |
| content             | text       |                                |
| type                | integer    | null:false                     |
| position            | integer    | null:false                     |
| room                | references | null: false, foreign_key: true |

### Association
- belongs_to :room
- has_many   :messages


## Messagesテーブル

| Column    | Type       | Options                        |
| --------- | ---------- | ------------------------------ |
| content   | text       | null: false                    |
| parent_id | integer    |                                |
| member    | references | null: false, foreign_key: true |
| agenda    | references | null: false, foreign_key: true |

### Association
- belongs_to :member
- belongs_to :agenda