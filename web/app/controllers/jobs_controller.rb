class JobsController < ApplicationController
    before_action :set_job, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]
  
    # GET /jobs
    def index
      @jobs = Job.order(created_at: :desc).page(params[:page]).per(10)
    end

      
    # GET /jobs/1
    def show
      # @job.views += 1
      # @job.save!
    end
  
    # GET /jobs/new
    def new
      @job = Job.new
    end
  
    # GET /jobs/1/edit
    def edit
    end
  
    # POST /jobs
    def create
      @job = current_user.jobs.new(job_params)
      
      if @job.save
        redirect_to @job, notice: 'Job was successfully created.'
      else
        render :new
      end
    end
  
    # PATCH/PUT /jobs/1
    def update
      if @job.update(job_params)
        redirect_to @job, notice: 'Job was successfully updated.'
      else
        render :edit
      end
    end
  
    # DELETE /jobs/1
    def destroy
      @job.destroy
      redirect_to jobs_url, notice: 'Job was successfully destroyed.'
    end
  
    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:title, :description, :job_type, :location, :company_name, :company_description, :company_website, :company_phone,
            :company_email, :company_contact, :details)
    end
  
    # Authorization: Ensure current user owns the job
    def authorize_user!
      redirect_to @job, alert: 'Not authorized.' unless @job.user == current_user || current_user.moderator?
    end
  end
  