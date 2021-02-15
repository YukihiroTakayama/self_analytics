# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_08_141116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budgets", force: :cascade do |t|
    t.integer "category_id"
    t.integer "price", default: 0, null: false
    t.integer "period_id"
    t.decimal "warning_percent", precision: 3, scale: 1, default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.integer "size", default: 3, null: false
    t.integer "type", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.boolean "calculating_target_flag", comment: "計算対象"
    t.date "transaction_date", comment: "日付"
    t.string "content", comment: "内容"
    t.integer "price", comment: "金額（円）"
    t.integer "owned_financial_facility", comment: "保有金融機関"
    t.integer "large_category_id", comment: "大項目"
    t.integer "medium_category_id", comment: "中項目"
    t.string "memo", comment: "メモ"
    t.boolean "transfer_flag", comment: "振替"
    t.string "moneyforward_id", comment: "ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "period_id"
  end

  create_table "fixed_expenses", force: :cascade do |t|
    t.boolean "calculating_target_flag", comment: "計算対象"
    t.date "transaction_date", comment: "日付"
    t.string "content", comment: "内容"
    t.integer "price", comment: "金額（円）"
    t.integer "owned_financial_facility", comment: "保有金融機関"
    t.integer "large_category_id", comment: "大項目"
    t.integer "medium_category_id", comment: "中項目"
    t.string "memo", comment: "メモ"
    t.boolean "transfer_flag", comment: "振替"
    t.string "moneyforward_id", comment: "ID"
    t.integer "period_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "incomes", force: :cascade do |t|
    t.boolean "calculating_target_flag", comment: "計算対象"
    t.date "transaction_date", comment: "日付"
    t.string "content", comment: "内容"
    t.integer "price", comment: "金額（円）"
    t.integer "owned_financial_facility", comment: "保有金融機関"
    t.integer "large_category_id", comment: "大項目"
    t.integer "medium_category_id", comment: "中項目"
    t.string "memo", comment: "メモ"
    t.boolean "transfer_flag", comment: "振替"
    t.string "moneyforward_id", comment: "ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "period_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.boolean "notified_flag", default: false, null: false
    t.text "message", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "periods", force: :cascade do |t|
    t.date "beginning_date"
    t.date "end_date"
    t.integer "year"
    t.integer "month"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "prediction_expenses", force: :cascade do |t|
    t.boolean "calculating_target_flag", comment: "計算対象"
    t.date "transaction_date", comment: "日付"
    t.string "content", comment: "内容"
    t.integer "price", comment: "金額（円）"
    t.integer "owned_financial_facility", comment: "保有金融機関"
    t.integer "large_category_id", comment: "大項目"
    t.integer "medium_category_id", comment: "中項目"
    t.string "memo", comment: "メモ"
    t.boolean "transfer_flag", comment: "振替"
    t.string "moneyforward_id", comment: "ID"
    t.integer "period_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
