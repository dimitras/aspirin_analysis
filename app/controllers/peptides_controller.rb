class PeptidesController < ApplicationController
  # GET /peptides
  # GET /peptides.json
  def index
    @peptides = Peptide.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @peptides }
    end
  end

  # GET /peptides/1
  # GET /peptides/1.json
  def show
    @peptide = Peptide.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @peptide }
    end
  end

  # GET /peptides/new
  # GET /peptides/new.json
  def new
    @peptide = Peptide.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @peptide }
    end
  end

  # GET /peptides/1/edit
  def edit
    @peptide = Peptide.find(params[:id])
  end

  # POST /peptides
  # POST /peptides.json
  def create
    @peptide = Peptide.new(params[:peptide])

    respond_to do |format|
      if @peptide.save
        format.html { redirect_to @peptide, :notice => 'Peptide was successfully created.' }
        format.json { render :json => @peptide, :status => :created, :location => @peptide }
      else
        format.html { render :action => "new" }
        format.json { render :json => @peptide.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /peptides/1
  # PUT /peptides/1.json
  def update
    @peptide = Peptide.find(params[:id])

    respond_to do |format|
      if @peptide.update_attributes(params[:peptide])
        format.html { redirect_to @peptide, :notice => 'Peptide was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @peptide.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /peptides/1
  # DELETE /peptides/1.json
  def destroy
    @peptide = Peptide.find(params[:id])
    @peptide.destroy

    respond_to do |format|
      format.html { redirect_to peptides_url }
      format.json { head :no_content }
    end
  end
end
