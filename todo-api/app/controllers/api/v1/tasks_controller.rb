module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:show, :update, :destroy]

      # GET /api/v1/tasks
      def index
        @tasks = Task.all

        # Filter by status if provided
        @tasks = @tasks.by_status(params[:status]) if params[:status].present?

        # Sort by field and direction if provided
        if params[:sortBy].present? && params[:order].present?
          @tasks = @tasks.sort_by_field(params[:sortBy], params[:order])
        end

        # Paginate results
        @tasks = @tasks.page(params[:page] || 1).per(params[:per_page] || 10)

        render json: @tasks
      end

      # GET /api/v1/tasks/:id
      def show
        render json: @task
      end

      # POST /api/v1/tasks
      def create
        @task = Task.new(task_params)

        if @task.save
          render json: @task, status: :created
        else
          render json: { code: 400, message: @task.errors.full_messages.join(', ') }, status: :bad_request
        end
      end

      # PATCH/PUT /api/v1/tasks/:id
      def update
        if @task.update(task_params)
          render json: @task
        else
          render json: { code: 400, message: @task.errors.full_messages.join(', ') }, status: :bad_request
        end
      end

      # DELETE /api/v1/tasks/:id
      def destroy
        @task.destroy
        head :no_content
      end

      private

      def set_task
        @task = Task.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { code: 404, message: 'Task not found' }, status: :not_found
      end

      def task_params
        params.require(:task).permit(:title, :description, :due_date, :priority, :status)
      end
    end
  end
end

