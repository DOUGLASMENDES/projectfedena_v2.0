class BatchesController < ApplicationController
  before_filter :init_data
  filter_access_to :all
  
  def index
    @batches = @course.batches
  end

  def new
    @batch = @course.batches.build
  end

  def create
    @batch = @course.batches.build(params[:batch])
    if @batch.save
      flash[:notice] = t('batches.created') 
      redirect_to [@course, @batch]
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @batch.update_attributes(params[:batch])
      flash[:notice] = t('batches.updated')
      redirect_to [@course, @batch]
    else
      flash[:notice] = t('batches.fill_all_fields') 
       redirect_to  edit_course_batch_path(@course, @batch)
    end
  end

  def show
    @students = @batch.students
  end

  def destroy
    if @batch.students.empty? and @batch.subjects.empty?
    @batch.inactivate
    flash[:notice] = t('batches.deleted') 
     redirect_to @course
    else
     flash[:warn_notice] = '<p>' + t('batches.unable_to_delete') + '</p>' if @batch.students.empty?
     flash[:warn_notice] = '<p>' + t('batches.unable_to_delete_subj_first') + '</p>' if @batch.subjects.empty?
   redirect_to [@course, @batch]
    end
  end

  private
  def init_data
    @batch = Batch.find params[:id] if ['show', 'edit', 'update', 'destroy'].include? action_name
    @course = Course.find params[:course_id]
  end
end
