class JobsController < ApplicationController
    before_action :set_job, only: [:show, :edit, :update, :destroy, :pin, :unpin]
    before_action :authenticate_user! #, only: [:new, :create, :edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]
    before_action :check_moderator, only: [:pin, :unpin]
    # GET /jobs
    def index
      @q = Job.where(visible: true).ransack(params[:q])
      @jobs = @q.result(distinct: true)
                .order(pinned: :desc, created_at: :desc)
                .page(params[:page])
                .per(10)
    end
    

      
    # GET /jobs/1
    def show
      # @job.views += 1
      # @job.save!
      @comments = @job.comments.includes(:replies).where(visible: true).order(created_at: :desc).page(params[:page]).per(10)
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
      existing_visible_job = current_user.jobs.find_by(visible: true)
  
      if existing_visible_job
        redirect_to jobs_url, alert: 'Please contact us to post additional jobs'
        return
      end
  
      @job = current_user.jobs.new(job_params)
  
      if @job.save
        redirect_to @job, notice: 'Job was successfully created.'
      else
        render :new
      end
    end
  
  
    # PATCH/PUT /jobs/1
    def update
      respond_to do |format|
        if @job.update(job_params)
          format.html { redirect_to @job, notice: 'Job was successfully updated.' }
          format.json { render :show, status: :ok, location: @job }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @job.errors, status: :unprocessable_entity }
        end
      end
    end
    
  
    # DELETE /jobs/1
    def destroy
      #@job.destroy
      @job.update(visible: false)
      redirect_to jobs_url, notice: 'Job was successfully destroyed.'
    end
  
    
    def flag
      @job = Job.find(params[:id])
      @job.increment!(:flags_count)
      # Add any additional logic like notifying admins, etc.

      redirect_to @job, notice: 'Job has been flagged.'
    end

    # Job pinning

    def pin
      if @job.update(pinned: true)
        redirect_to jobs_path, notice: 'Job was successfully pinned.'
      else
        redirect_to jobs_path, alert: 'Unable to pin the job.'
      end
    end
  
    def unpin
      if @job.update(pinned: false)
        redirect_to jobs_path, notice: 'Job was successfully unpinned.'
      else
        redirect_to jobs_path, alert: 'Unable to unpin the job.'
      end
    end
  
  

    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:title, :description, :job_type, :location, :company_name, :company_description, :company_website, :company_phone,
            :company_email, :company_contact, :details, :q)
    end
  
    # Authorization: Ensure current user owns the job
    def authorize_user!
      redirect_to @job, alert: 'Not authorized.' unless @job.user == current_user || current_user.moderator?
    end

    def check_moderator
      redirect_to(root_url) unless current_user.moderator?
    end
  end
  