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

    # usando amortization schedule
    # http://stackoverflow.com/questions/30305447/how-to-build-an-amortization-table-in-ruby
    cada_cuota = project[:price] / simulation_params[:cuotas].to_f

    # Periods
    fee = simulation_params[:cuotas].to_f

    # Rate - Tarifa - Interés
    rate = simulation_params[:tasa].to_i

    # Amount borrowed
    loan_amount = current_user.budget

    #project_price = project[:price].to_f

    # Payment
    pmt = loan_amount * ((rate * ( 1 + rate)**fee) / (( 1 + rate )**fee - 1))

    payments = (1..simulation_params[:cuotas].to_i).map do |cuota|
      {
        cuota: cuota.to_i,
        loan_amount: loan_amount,
        pmt: pmt,
        interest: loan_amount * rate,
        principal: pmt - (loan_amount * rate),
        fetcha: cuota.to_i.months.from_now.strftime("%Y-%m-%d"),
        valor: loan_amount - (pmt - (loan_amount * rate)),
      }
    end

    render json: payments
  end

  private

    def simulation_params
      params.require(:simulation).permit(:project_id, :tasa, :cuotas).merge(current_user: current_user.id)
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
