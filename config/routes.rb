Rails.application.routes.draw do
  resources :students do
    resources :installment_plans do
      resources :payments
    end
  end
end