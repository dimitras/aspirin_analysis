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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120905031150) do

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "peptides", :force => true do |t|
    t.string   "pep_seq"
    t.float    "rank_product"
    t.float    "penalized_rp"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "proteins", :force => true do |t|
    t.string   "accno"
    t.string   "desc"
    t.string   "seq"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "psms", :force => true do |t|
    t.string   "pep_seq"
    t.string   "query"
    t.string   "accno"
    t.float    "pep_score"
    t.string   "rep"
    t.string   "mod"
    t.string   "genename"
    t.float    "cutoff"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "mod_positions"
    t.string   "title"
    t.string   "charge"
    t.string   "rtinseconds"
    t.binary   "mzs"
    t.binary   "intensities"
    t.integer  "peptide_id"
    t.binary   "assigned_yions"
  end

  add_index "psms", ["peptide_id"], :name => "index_psms_on_peptide_id"

  create_table "spectras", :force => true do |t|
    t.string   "query"
    t.string   "title"
    t.string   "ions1"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
