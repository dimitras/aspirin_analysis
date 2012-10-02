class ProteinsController < ApplicationController
  # GET /proteins
  # GET /proteins.json
  def index
    @proteins = Protein.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @proteins }
    end
  end

  # GET /proteins/1
  # GET /proteins/1.json
  def show
    @protein = Protein.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @protein }
    end
  end

  # GET /proteins/new
  # GET /proteins/new.json
  def new
    @protein = Protein.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @protein }
    end
  end

  # GET /proteins/1/edit
  def edit
    @protein = Protein.find(params[:id])
  end

  # POST /proteins
  # POST /proteins.json
  def create
    @protein = Protein.new(params[:protein])

    respond_to do |format|
      if @protein.save
        format.html { redirect_to @protein, :notice => 'Protein was successfully created.' }
        format.json { render :json => @protein, :status => :created, :location => @protein }
      else
        format.html { render :action => "new" }
        format.json { render :json => @protein.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /proteins/1
  # PUT /proteins/1.json
  def update
    @protein = Protein.find(params[:id])

    respond_to do |format|
      if @protein.update_attributes(params[:protein])
        format.html { redirect_to @protein, :notice => 'Protein was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @protein.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /proteins/1
  # DELETE /proteins/1.json
  def destroy
    @protein = Protein.find(params[:id])
    @protein.destroy

    respond_to do |format|
      format.html { redirect_to proteins_url }
      format.json { head :no_content }
    end
  end
end
