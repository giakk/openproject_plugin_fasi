module OpenProject
  module PhasesPlugin
    class Engine < ::Rails::Engine
      engine_name :openproject_phases_plugin

      include OpenProject::Plugins::ActsAsOpEngine

      register 'openproject-phases_plugin',
               author_url: 'https://github.com/giakk',
               bundled: false do


        project_module :phases_overview_module do
          permission :view_phases_overview,
                      { phases_overview: [:index] },
                      permissible_on: :global,
                      contract_actions: { phases_overview: [:index] }
          
          permission :edit_phases_overview,
                      { phases_overview: [:update] },
                      permissible_on: :global,
                      contract_actions: { phases_overview: [:update] },
                      require: :member
        end

        # Menu nella homepage globale per l'overview delle fasi
        menu :top_menu,
             :phases_overview,
             { controller: '/phases_overview', action: 'index' },
             caption: 'Panoramica Fasi',
             after: :gantt,
             icon: 'check-circle',
             if: Proc.new { User.current.logged? }
        

        project_module :fase_a_module do
          permission :view_fase_a_data,
                     { fase_a_data: [:show] },
                     permissible_on: :project,
                     contract_actions: { fase_a_data: [:show] }
          
          permission :edit_fase_a_data,
                     { fase_a_data: [:update] },
                     permissible_on: :project,
                     contract_actions: { fase_a_data: [:update] },
                     require: :member
        end

        menu :project_menu,
             :fase_a_data,
             { controller: '/fase_a_data', action: 'show' },
             param: :project_id,
             caption: 'Fase A',
             after: :gantt,
             icon: 'check-circle',
             if: ->(project) { true }


        project_module :fase_b_module do
          permission :view_fase_b_data,
                     { fase_b_data: [:show] },
                     permissible_on: :project,
                     contract_actions: { fase_b_data: [:show] }
          
          permission :edit_fase_b_data,
                     { fase_b_data: [:update] },
                     permissible_on: :project,
                     contract_actions: { fase_b_data: [:update] },
                     require: :member
        end

        menu :project_menu,
             :fase_b_data,
             { controller: '/fase_b_data', action: 'show' },
             param: :project_id,
             caption: 'Fase B',
             after: :fase_a_data,
             icon: 'check-circle',
             if: ->(project) { true }

        
        project_module :fase_c_module do
          permission :view_fase_c_data,
                     { fase_c_data: [:show] },
                     permissible_on: :project,
                     contract_actions: { fase_c_data: [:show] }
          
          permission :edit_fase_c_data,
                     { fase_c_data: [:update] },
                     permissible_on: :project,
                     contract_actions: { fase_c_data: [:update] },
                     require: :member
        end

        menu :project_menu,
             :fase_c_data,
             { controller: '/fase_c_data', action: 'show' },
             param: :project_id,
             caption: 'Fase C',
             after: :fase_b_data,
             icon: 'check-circle',
             if: ->(project) { true }

        
      end

      config.before_configuration do |app|
        app.config.paths['config/locales'] << File.expand_path('../../../config/locales', __dir__)
      end

      initializer 'fase_c_plugin.append_migrations' do |app|
        unless app.root.to_s.match?(root.to_s)
          config.paths['db/migrate'].expanded.each do |expanded_path|
            app.config.paths['db/migrate'] << expanded_path
          end
        end
      end

      config.to_prepare do
        # Aggiungi patches se necessario
      end
    end
  end
end