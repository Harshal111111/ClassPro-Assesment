class InstallmentPlansController < ApplicationController
  def new
    @student = Student.find(params[:student_id])
    @installment_plan = @student.installment_plans.new
  end

  def create
    @student = Student.find(params[:student_id])
    @installment_plan = @student.installment_plans.new(installment_plan_params)

    if @installment_plan.save
      redirect_to @student, notice: 'Installment plan was successfully created.'
    else
      flash.now[:alert] = @installment_plan.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def installment_plan_params
    params.require(:installment_plan).permit(:total_amount, :number_of_installments)
  end
end