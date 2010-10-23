class NeuronsController < ApplicationController
  # GET /neurons
  # GET /neurons.xml
  def synapses
    @tab = "synapses"
  end
  
  def index
    redirect_to :action => "new"
  end
    
  def list
    @tab = "browse"
    @neurons = Neuron.all

    respond_to do |format|
      format.html # list.html.erb
      format.xml  { render :xml => @neurons }
    end
  end

  # GET /neurons/1
  # GET /neurons/1.xml
  def show
    @tab = "browse"
    @neuron = Neuron.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @neuron }
    end
  end

  # GET /neurons/new
  # GET /neurons/new.xml
  def new
    @tab = "new"
    @neuron = Neuron.new
    4.times { @neuron.assets.build }
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @neuron }
    end
  end

  # GET /neurons/1/edit
  def edit
    @neuron = Neuron.find(params[:id])
    4.times { @neuron.assets.build }
  end

  # POST /neurons
  # POST /neurons.xml
  def create
    @neuron = Neuron.new(params[:neuron])

    respond_to do |format|
      if @neuron.save
        format.html { redirect_to(@neuron, :notice => 'Neuron was successfully created.') }
        format.xml  { render :xml => @neuron, :status => :created, :location => @neuron }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @neuron.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /neurons/1
  # PUT /neurons/1.xml
  def update
    @neuron = Neuron.find(params[:id])

    respond_to do |format|
      if @neuron.update_attributes(params[:neuron])
        format.html { redirect_to(@neuron, :notice => 'Neuron was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @neuron.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /neurons/1
  # DELETE /neurons/1.xml
  def destroy
    @neuron = Neuron.find(params[:id])
    @neuron.destroy

    respond_to do |format|
      format.html { redirect_to :action => "list" }
      format.xml  { head :ok }
    end
  end
  
	# Executes a search query on the database (cf. model file for the definition of Neuron.search)
	def search
    @query=params[:search]
    @neurons = Neuron.search(params[:search])
  end
  
  def label
    @label=params[:id]
    @neurons = Neuron.search_label(params[:id])    
  end
end
