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

ActiveRecord::Schema.define(:version => 20130307152709) do

  create_table "conservations", :force => true do |t|
    t.string   "mrna_id"
    t.string   "species"
    t.text     "seq"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "conservations", ["mrna_id"], :name => "index_conservations_on_mrna_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "peptidepsms", :force => true do |t|
    t.integer  "peptide_id"
    t.integer  "psm_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "peptides", :force => true do |t|
    t.string   "pep_seq"
    t.float    "rank_product"
    t.float    "penalized_rp"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.float    "cutoff"
    t.string   "experiment"
    t.integer  "top_peaks_assigned"
  end

  add_index "peptides", ["pep_seq"], :name => "index_peptides_on_pep_seq"
  add_index "peptides", ["top_peaks_assigned"], :name => "index_peptides_on_top_peaks_assigned"

  create_table "proteinpsms", :force => true do |t|
    t.integer  "protein_id"
    t.integer  "psm_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "proteins", :force => true do |t|
    t.string   "accno"
    t.string   "desc"
    t.string   "species"
    t.text     "seq"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "genename"
  end

  add_index "proteins", ["accno"], :name => "index_proteins_on_accno"
  add_index "proteins", ["species"], :name => "index_proteins_on_species"

  create_table "psms", :force => true do |t|
    t.string   "pep_seq"
    t.string   "query"
    t.string   "accno"
    t.float    "pep_score"
    t.string   "rep"
    t.string   "mod"
    t.float    "cutoff"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "mod_positions"
    t.string   "title"
    t.string   "charge"
    t.string   "rtinseconds"
    t.binary   "mzs"
    t.binary   "intensities"
    t.string   "mrna_id"
    t.string   "mod_positions_in_protein"
    t.string   "conserved_mod_positions_in_protein"
    t.text     "enzyme"
    t.binary   "assigned_yions_mzs_table"
    t.binary   "assigned_yions_intensities_table"
    t.binary   "assigned_bions_mzs_table"
    t.binary   "assigned_bions_intensities_table"
    t.binary   "yions"
    t.binary   "bions"
    t.binary   "assigned_yions_with05tol_mzs_table"
    t.binary   "assigned_yions_with05tol_intensities_table"
    t.binary   "assigned_bions_with05tol_mzs_table"
    t.binary   "assigned_bions_with05tol_intensities_table"
  end

  add_index "psms", ["pep_seq"], :name => "index_psms_on_pep_seq"

  create_table "spectras", :force => true do |t|
    t.string   "query"
    t.string   "title"
    t.string   "ions1"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
