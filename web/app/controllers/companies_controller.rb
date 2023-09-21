class CompaniesController < ApplicationController
  before_action :set_company, only: %i[ show edit update destroy ]
  before_action :check_user, only: [:edit, :update, :destroy]



  # GET /companies or /companies.json
  def index
    #@companies = Company.all

    @q = Company.ransack(params[:q])
 
 #   @q = Company.ransack(name_cont: 'company_name', category_eq: 'category_name')

    # Show 10 companies per page
    #@companies = @q.result(distinct: true).page(params[:page]).per(10) 
    @companies = @q.result(distinct: true).order(name: :asc).page(params[:page]).per(10)


  end

  # GET /companies/1 or /companies/1.json
  def show
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
    @company = Company.new(company_params)
    @company.user = current_user

    respond_to do |format|
      if @company.save
        format.html { redirect_to company_url(@company), notice: "Company was successfully created." }
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
    
end
