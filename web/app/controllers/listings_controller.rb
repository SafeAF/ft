class ListingsController < ApplicationController
  before_action :set_listing, only: %i[ show edit update destroy pin unpin ]
  before_action :authenticate_user! #, except: [:show, :index] # Ensure the user is logged in for all actions except show and index
  before_action :check_owner, only: %i[edit update destroy] # Check if the current user is the owner before edit, update, or destroy

  # For pinning
  before_action :check_moderator, only: [:pin, :unpin]

 
  # GET /listings or /listings.json
  def index
    @q = Listing.ransack(params[:q])
    # Select listings that are visible and order them with pinned listings first.
    # Ensure that the pinned listings are also sorted by their creation date.
    @listings = @q.result(distinct: true)
                  .where(visible: true)
                  .order(pinned: :desc, created_at: :desc)
                  .page(params[:page])
                  .per(10)
  end
  

  # GET /listings/1 or /listings/1.json
  def show
    @listing.views += 1
    @listing.save!
    @comments = @listing.comments.includes(:replies).where(visible: true).order(created_at: :desc).page(params[:page]).per(10)
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings or /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user

    respond_to do |format|
      if @listing.save
        format.html { redirect_to listing_url(@listing), notice: "Listing was successfully created." }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1 or /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to listing_url(@listing), notice: "Listing was successfully updated." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1 or /listings/1.json
  def destroy
    @listing.update(visible: false)
    #@listing.destroy

    respond_to do |format|
      format.html { redirect_to listings_url, notice: "Listing was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def flag
    @listing = Listing.find(params[:id])
    @listing.increment!(:flags_count)
    redirect_to @listing, notice: 'Listing has been flagged for review.'
  end

  # Pin listings to the top

  def pin
    @listing.update(pinned: true)
    redirect_to listings_path, notice: 'Listing was successfully pinned.'
  end

  def unpin
    @listing.update(pinned: false)
    redirect_to listings_path, notice: 'Listing was successfully unpinned.'
  end

  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:title, :description, :location,
         :price, :views, :content, :thumbnail, :category, :q)
    end
    
  # Check if the current user is the owner of the listing
  def check_owner
    unless @listing.user == current_user || current_user.moderator?
      redirect_to listings_path, alert: "You don't have permission to do that."
    end
  end
  
  def check_moderator
    redirect_to(root_url) unless current_user.moderator?
  end

end
