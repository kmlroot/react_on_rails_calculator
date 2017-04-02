class AmortizationSchedule
  attr_accessor :initial_loan_amount, :quotas, :yearly_rate, :monthly_rate

  def initialize(loan_amount, quotas, yearly_rate)
    @initial_loan_amount = loan_amount
    @quotas = quotas
    @yearly_rate = yearly_rate > 1 ? yearly_rate / 100.0 : yearly_rate
    @monthly_rate = @yearly_rate / 12.0
  end

  def monthly_amount
    initial_loan_amount * ( (monthly_rate * ( 1 + monthly_rate)**quotas) / ( ( 1 + monthly_rate )**quotas - 1) )
  end

  def payments
    remaining_loan_amount = initial_loan_amount

    (1..quotas).map do |period|
      remaining_loan_amount = remaining_loan_amount * (1 + monthly_rate) - monthly_amount

      {
        period: period,
        amount: monthly_amount.round(2),
        loan_remaining: remaining_loan_amount.round(2),
        date: period.months.from_now.to_date.to_s(:db)
      }
    end
  end
end
