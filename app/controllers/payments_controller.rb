class PaymentsController < ApplicationController
  before_action :set_student
  before_action :set_installment_plan

  def new
    @payment = @installment_plan.payments.new
  end

  def create
    @payment = @installment_plan.payments.new(payment_params)
    @payment.student = @student

    if @payment.amount > @installment_plan.remaining_balance
      flash.now[:alert] = "Payment amount cannot exceed the remaining balance."
      render :new
    elsif @payment.save
      handle_payment
      redirect_to @student, notice: 'Payment was successfully processed.'
    else
      render :new
    end
  end

  private
  def set_student
    @student = Student.find(params[:student_id])
  end

  def set_installment_plan
    @installment_plan = @student.installment_plans.find(params[:installment_plan_id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :installment_index)
  end

  def handle_payment
    installment_index = @payment.installment_index
    current_installments = @installment_plan.installments
    current_installment = current_installments[installment_index].to_f
    difference = @payment.amount.to_f - current_installment

    if difference > 0
      current_installments = handle_overpayment(current_installments, difference, installment_index)
    elsif difference < 0
      current_installments = handle_underpayment(current_installments, difference.abs, installment_index)
    end

    current_installments[installment_index] = @payment.amount.to_f
    @installment_plan.update(installments: current_installments.map(&:to_s))
  end

  def handle_overpayment(installments, extra_amount, current_index)
    (current_index + 1...installments.size).each do |i|
      if extra_amount > 0
        if extra_amount >= installments[i]
          extra_amount -= installments[i]
          installments[i] = 0
        else
          installments[i] -= extra_amount
          extra_amount = 0
        end
      else
        break
      end
    end
    installments
  end

  def handle_underpayment(installments, remaining_amount, current_index)
    if params[:action_type] == 'add_to_next'
      next_index = current_index + 1
      if next_index < installments.size
        installments[next_index] += remaining_amount
      else
        installments << remaining_amount
      end
    elsif params[:action_type] == 'create_new'
      installments << remaining_amount
    end
    installments
  end
end