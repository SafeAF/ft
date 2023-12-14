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

ActiveRecord::Schema[7.0].define(version: 2023_12_14_202651) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "advertisers", force: :cascade do |t|
    t.string "name"
    t.text "details"
    t.string "status"
    t.text "billing_info"
    t.string "contact_name"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adverts", force: :cascade do |t|
    t.string "name"
    t.string "alt_text"
    t.string "link_url"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "click_count", default: 0
    t.integer "impressions", default: 0
    t.string "status"
    t.string "position"
    t.integer "prominence"
    t.string "display_locations"
    t.string "tags"
    t.integer "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ad_type"
    t.index ["campaign_id"], name: "index_adverts_on_campaign_id"
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.integer "visit_id"
    t.integer "user_id"
    t.string "name"
    t.text "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.integer "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "articles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.text "description"
    t.string "location"
    t.integer "views", default: 0
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "flags_count", default: 0
    t.boolean "visible", default: true
    t.boolean "pinned", default: false
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "badges", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "image_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banned_ips", force: :cascade do |t|
    t.string "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "budget"
    t.date "start_date"
    t.date "end_date"
    t.integer "status", default: 0
    t.integer "advertiser_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["advertiser_id"], name: "index_campaigns_on_advertiser_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "content"
    t.string "commentable_type", null: false
    t.integer "commentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "flags_count", default: 0
    t.boolean "visible", default: true
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "contact"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.string "website"
    t.string "hours"
    t.text "about"
    t.string "category"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pinned", default: false
    t.string "slug"
    t.index ["slug"], name: "index_companies_on_slug", unique: true
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id", null: false
    t.integer "recipient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "job_type"
    t.string "location"
    t.string "company_name"
    t.text "company_description"
    t.string "company_website"
    t.string "company_phone"
    t.string "company_email"
    t.string "company_contact"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "flags_count", default: 0
    t.boolean "visible", default: true
    t.boolean "pinned", default: false
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "listings", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "location"
    t.float "price"
    t.integer "views", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "category"
    t.integer "flags_count", default: 0
    t.boolean "visible", default: true
    t.boolean "pinned", default: false
    t.index ["user_id"], name: "index_listings_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "conversation_id", null: false
    t.integer "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false
    t.boolean "deleted", default: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "notifiable_type", null: false
    t.integer "notifiable_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "poasts", force: :cascade do |t|
    t.string "title"
    t.string "subheading"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true
    t.integer "flags_count", default: 0
    t.integer "views", default: 0
    t.boolean "pinned", default: false
    t.index ["user_id"], name: "index_poasts_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "replies", force: :cascade do |t|
    t.text "content"
    t.integer "comment_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true
    t.integer "flags_count", default: 0
    t.index ["comment_id"], name: "index_replies_on_comment_id"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "user_badges", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "badge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_user_badges_on_badge_id"
    t.index ["user_id", "badge_id"], name: "index_user_badges_on_user_id_and_badge_id", unique: true
    t.index ["user_id"], name: "index_user_badges_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "location"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "moderator", default: false
    t.boolean "locked", default: false
    t.boolean "administrator", default: false
    t.string "last_ip_address"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "adverts", "campaigns"
  add_foreign_key "articles", "users"
  add_foreign_key "campaigns", "advertisers"
  add_foreign_key "comments", "users"
  add_foreign_key "companies", "users"
  add_foreign_key "conversations", "users", column: "recipient_id"
  add_foreign_key "conversations", "users", column: "sender_id"
  add_foreign_key "jobs", "users"
  add_foreign_key "listings", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "poasts", "users"
  add_foreign_key "replies", "comments"
  add_foreign_key "replies", "users"
  add_foreign_key "user_badges", "badges"
  add_foreign_key "user_badges", "users"
end
