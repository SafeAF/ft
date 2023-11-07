class CompaniesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_company, only: %i[ show edit update destroy pin unpin ]
  before_action :check_user, only: [:edit, :update, :destroy]
  before_action :check_moderator, only: [:pin, :unpin]


  # GET /companies or /companies.json
  def index
    @q = Company.ransack(params[:q])
  
    # Sort companies by `pinned` (descending so true comes first), then by `name` (ascending)
    # `pinned` column should be boolean type, add it to your companies table if not already present
    @companies = @q.result(distinct: true)
                   .order(pinned: :desc, name: :asc)
                   .page(params[:page]).per(10)
  end
  

  
  def show
    @company = Company.find(params[:id])
    @comments = @company.comments.includes(:replies).where(visible: true).order(created_at: :desc).page(params[:page]).per(10)

  end


  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies or /companies.json
  def create
    # Check if the current user already has a company
    existing_company = Company.find_by(user: current_user)
  
    if existing_company
      # Redirect the user to their existing company with a message
      redirect_to company_url(existing_company), alert: 'Please contact us to list more than one business.'
      return
    end
  
    @company = Company.new(company_params)
    @company.user = current_user
  
    respond_to do |format|
      if @company.save
        format.html { redirect_to company_url(@company), notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /companies/1 or /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to company_url(@company), notice: "Company was successfully updated." }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1 or /companies/1.json
  def destroy
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url, notice: "Company was successfully destroyed." }
      format.json { head :no_content }
    end
  end


    # Pin articles

  def pin
    if @company.update(pinned: true)
      redirect_to companies_path, notice: 'Company was successfully pinned.'
    else
      redirect_to companies_path, alert: 'Unable to pin the company.'
    end
  end

  def unpin
    if @company.update(pinned: false)
      redirect_to companies_path, notice: 'Company was successfully unpinned.'
    else
      redirect_to companies_path, alert: 'Unable to unpin the company.'
    end
  end


  private


    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_params
      params.require(:company).permit(:name, :contact, :address, :phone, :email, :website,
         :hours, :about, :category, :description, :logo, :q)
    end

    # only allow the user that created the company to destroy it.
    def check_user
      unless @company.user == current_user || current_user.moderator?
        redirect_to companies_path, alert: "Sorry, you aren't allowed to edit this company."
      end
    end

    def check_moderator
      redirect_to(root_url) unless current_user.moderator?
    end
end
