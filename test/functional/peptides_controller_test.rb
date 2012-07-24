require 'test_helper'

class PeptidesControllerTest < ActionController::TestCase
  setup do
    @peptide = peptides(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:peptides)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create peptide" do
    assert_difference('Peptide.count') do
      post :create, :peptide => { :more => @peptide.more, :penalized_rp => @peptide.penalized_rp, :pep_seq => @peptide.pep_seq, :rank_product => @peptide.rank_product }
    end

    assert_redirected_to peptide_path(assigns(:peptide))
  end

  test "should show peptide" do
    get :show, :id => @peptide
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @peptide
    assert_response :success
  end

  test "should update peptide" do
    put :update, :id => @peptide, :peptide => { :more => @peptide.more, :penalized_rp => @peptide.penalized_rp, :pep_seq => @peptide.pep_seq, :rank_product => @peptide.rank_product }
    assert_redirected_to peptide_path(assigns(:peptide))
  end

  test "should destroy peptide" do
    assert_difference('Peptide.count', -1) do
      delete :destroy, :id => @peptide
    end

    assert_redirected_to peptides_path
  end
end
