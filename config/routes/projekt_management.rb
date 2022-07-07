namespace :projekt_management do
  root to: "projekts#index"


  # custom projekt routes
  resources :projekts, only: [:index, :edit] do
  # resources :projekts, only: [:index, :edit, :update] do
  #   resources :settings, controller: 'projekt_settings', only: [:update] do
  #     member do
  #       patch :update_default_projekt_footer_tab
  #     end
  #   end
  #   resources :projekt_notifications, only: [:create, :update, :destroy]
  #   resources :projekt_events, only: [:create, :update, :destroy]
    resources :projekt_questions, only: [:new, :edit]  #do
      # post "/answers/order_answers", to: "questions/answers#order_answers"
    #end
  #   resources :milestones, controller: "projekt_milestones"
  #   resources :progress_bars, except: :show, controller: "projekt_progress_bars"
  #   member do
  #     get :order_up
  #     get :order_down
  #     patch :liveupdate
  #     patch :update_standard_phase
  #     patch :quick_update
  #   end
  #   patch :update_map, to: "projekts#update_map"

  #   resources :map_layers, only: [:update, :create, :edit, :new, :destroy], controller: 'projekts/map_layers'
  # end
  end



  # resources :projekts, only: [:index, :edit, :update] do
  #   put :hide, on: :member
  #   put :moderate, on: :collection
  # end  

  # resources :debates, only: [:index, :update, :show] do
  #   put :hide, on: :member
  #   put :moderate, on: :collection
  # end

  # resources :proposals, only: [:index, :update, :show] do
  #   put :hide, on: :member
  #   put :moderate, on: :collection
  # end

  # namespace :legislation do
  #   resources :proposals, only: :index do
  #     put :hide, on: :member
  #     put :moderate, on: :collection
  #   end
  # end
  # resources :comments, only: :index do
  #   put :hide, on: :member
  #   put :moderate, on: :collection
  # end

  # resources :proposal_notifications, only: :index do
  #   put :hide, on: :member
  #   put :moderate, on: :collection
  # end

  # resources :administrator_tasks, only: %i[index edit update]

  # resources :budget_investments, only: :index, controller: "budgets/investments" do
  #   put :hide, on: :member
  #   put :moderate, on: :collection
  # end
end
