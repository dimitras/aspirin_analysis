require 'psm'

class PeptidesController < ApplicationController
  # GET /peptides
  # GET /peptides.json
  def index
    if !params[:cutoff] || params[:cutoff] == ''
      cutoff = 10
    else
      cutoff = params[:cutoff]
    end
    
    # @pep = Peptide.find(params[:id])
    # if !params[:experiment] || params[:experiment] == ''
    #   @peptides = Peptide.common_through_experiments(@pep.pep_seq, cutoff) if Peptide.common_through_experiments(@pep.pep_seq, cutoff).size > 1
    # else
      @peptides = Peptide.filtered(params[:experiment], cutoff)
    # end

    if params[:length_threshold] && params[:length_threshold] != ''
       @peptides = @peptides.longer_than(params[:length_threshold].to_i)
    end

    if params[:enzyme] && params[:enzyme] != ''
      @peptides = @peptides.enzymed(params[:enzyme])
    end

    @peptides = @peptides.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @peptides }
    end
  end

  def search
    @peptides = Peptide.search params[:search]
  end
  
  # GET /peptides/1
  # GET /peptides/1.json
  def show
    @peptide = Peptide.find(params[:id])
    logger.info("PEPTIDE: (#{params[:id]}) #{@peptide.pep_seq}")

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
