class SimulationsController < ApplicationController

  # Callbacks

  skip_before_action :verify_authenticity_token
  before_action :send_data
  before_action :authenticate_user!

  # Methods

  def new
  end

  def create
    project = @projects_props.find{ |project| project[:id] == simulation_params[:project_id].to_i }

    fee = simulation_params[:fee].to_f
    rate = simulation_params[:interest].to_i / 12.0
    project_price = project[:price].to_f

    amortization = AmortizationSchedule.new(project_price, fee, rate)

    render json: amortization.payments
  end

  private

    def simulation_params
      params.require(:simulation).permit(:project_id, :fee, :interest).merge(current_user: current_user.id)
    end

    def send_data
      user_id = current_user.id
      user_name = current_user.name
      user_budget = current_user.budget

      @user_props = {
        id: user_id,
        name: user_name,
        budget: user_budget
      }

      @projects_props = []

      current_user.projects.each do |project|
        @projects_props.push({
          id: project.id,
          name: project.name,
          initial_fee: project.initial_fee,
          price: project.price,
          user_id: project.user_id
        })
      end
    end
end
