# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161128004637) do

  create_table "branches", force: :cascade do |t|
    t.datetime "git_updated_at",              null: false
    t.text     "name",           limit: 1024, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.integer  "repository_id"
  end

  add_index "branches", ["author_id"], name: "index_branches_on_author_id"
  add_index "branches", ["repository_id"], name: "index_branches_on_repository_id"

  create_table "commits", force: :cascade do |t|
    t.text     "sha",           limit: 40,   null: false
    t.text     "message",       limit: 1024, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.integer  "jira_issue_id"
  end

  add_index "commits", ["author_id"], name: "index_commits_on_author_id"
  add_index "commits", ["jira_issue_id"], name: "index_commits_on_jira_issue_id"

  create_table "commits_and_pushes", force: :cascade do |t|
    t.string  "errors_json",   limit: 256
    t.boolean "ignore_errors",             default: false
    t.integer "push_id"
    t.integer "commit_id"
  end

  add_index "commits_and_pushes", ["commit_id"], name: "index_commits_and_pushes_on_commit_id"
  add_index "commits_and_pushes", ["push_id"], name: "index_commits_and_pushes_on_push_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "jira_issues", force: :cascade do |t|
    t.text     "key",                      limit: 255,  null: false
    t.text     "issue_type",               limit: 255,  null: false
    t.text     "summary",                  limit: 1024, null: false
    t.text     "status",                   limit: 255,  null: false
    t.date     "targeted_deploy_date"
    t.text     "post_deploy_check_status", limit: 255
    t.text     "deploy_type",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assignee_id"
    t.integer  "parent_issue_id"
    t.text     "secrets_modified",         limit: 255
    t.text     "long_running_migration",   limit: 255
  end

  add_index "jira_issues", ["assignee_id"], name: "index_jira_issues_on_assignee_id"
  add_index "jira_issues", ["parent_issue_id"], name: "index_jira_issues_on_parent_issue_id"

  create_table "jira_issues_and_pushes", force: :cascade do |t|
    t.string  "errors_json",   limit: 256
    t.boolean "ignore_errors",             default: false
    t.integer "push_id"
    t.integer "jira_issue_id"
  end

  add_index "jira_issues_and_pushes", ["jira_issue_id"], name: "index_jira_issues_and_pushes_on_jira_issue_id"
  add_index "jira_issues_and_pushes", ["push_id"], name: "index_jira_issues_and_pushes_on_push_id"

  create_table "pushes", force: :cascade do |t|
    t.string   "status",         limit: 32
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "head_commit_id"
    t.integer  "branch_id"
  end

  add_index "pushes", ["branch_id"], name: "index_pushes_on_branch_id"
  add_index "pushes", ["head_commit_id"], name: "index_pushes_on_head_commit_id"

  create_table "repositories", force: :cascade do |t|
    t.text     "name",       limit: 1024, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.text     "name",       limit: 255, null: false
    t.text     "email",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
