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
        fetcha: period.months.from_now.to_date.to_s(:db)
      }
    end
  end
end

# valor de 32000, 40 quotas, 4% rate
amortization = AmortizationSchedule.new(32000, 40, 0.04)
amortization.payments

# valor de 1000, 1 quota, 10% rate
amortization = AmortizationSchedule.new(1000, 1, 0.10)
amortization.payments
