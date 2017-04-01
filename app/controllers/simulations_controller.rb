class SimulationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :fake_data

  def new
    # @user_props = current_user
    # @projects_props = current_user.projects
  end

  def create
    # project = current_user.projects.find(simulation_params[:project_id])
    project = @projects_props.find{ |project| project[:id] == simulation_params[:project_id].to_i }

    # usando amortization schedule
    # http://stackoverflow.com/questions/30305447/how-to-build-an-amortization-table-in-ruby
    cada_cuota = project[:price] / simulation_params[:cuotas].to_f

    payments = (1..simulation_params[:cuotas].to_i).map do |cuota|
      {
        cuota: cuota.to_i,
        fetcha: cuota.to_i.months.from_now,
        valor: cada_cuota
      }
    end

    render json: payments
  end

  private

  def simulation_params
    params.require(:simulation).permit(:project_id, :tasa, :cuotas)
  end

  def fake_data
    @user_props = {
      id: 1,
      name: 'Mauri',
      budget: 1000
    }
    @projects_props = [
      {id: 1, name: 'Proj 1', initial_fee: 5, price: 500, user_id: 1},
      {id: 2, name: 'Proj 2', initial_fee: 1, price: 550, user_id: 1},
      {id: 3, name: 'Proj 3', initial_fee: 0, price: 100, user_id: 1}
    ]
  end
end
