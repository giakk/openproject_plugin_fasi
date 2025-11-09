OpenProject::Application.routes.draw do
  scope '', as: 'phases_plugin' do
    scope 'projects/:project_id', as: 'project' do
      resource :fase_a_data, 
              controller: 'fase_a_data',
              only: [:show, :update]
      resource :fase_b_data, 
              controller: 'fase_b_data',
              only: [:show, :update]
      resource :fase_c_data, 
              controller: 'fase_c_data',
              only: [:show, :update]        
    end
  end
end
