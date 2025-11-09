class FaseCDatum < ApplicationRecord
  belongs_to :project

  validates :project_id, uniqueness: true
  validates :collaudo_impianto, length: { maximum: 100 }, allow_blank: true
  validates :libretto_impianto, length: { maximum: 100 }, allow_blank: true
  validates :dichiarazione_ce, length: { maximum: 100 }, allow_blank: true
  validates :contratto_manutenzione, length: { maximum: 100 }, allow_blank: true
  validates :incarico_ente_certificato, length: { maximum: 100 }, allow_blank: true
  validates :numero_matricola, length: { maximum: 100 }, allow_blank: true
  validates :fine_lavori_pratica, length: { maximum: 100 }, allow_blank: true
  validates :variazione_catastale, length: { maximum: 100 }, allow_blank: true

  def self.for_project(project)
    find_or_initialize_by(project: project)
  end
end