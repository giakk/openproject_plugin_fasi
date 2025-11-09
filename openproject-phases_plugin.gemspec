
Gem::Specification.new do |s|
  s.name        = "openproject-phases_plugin"
  s.version     = "1.0.0"
  s.authors     = ["Riccardo Giacchino"]
  s.email       = ["giacchinoriccardo@outlook.it"]
  s.summary     = "Plugin per gestire le fasi dei progetti"
  s.description = "Gestisce i dati relativi ad ogni fase dei progetti"
  s.license     = "GPLv3"

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)
  
  s.add_dependency "rails", ">= 7.0"
end
