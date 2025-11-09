class FaseADatum < ApplicationRecord
  belongs_to :project

  validates :project_id, uniqueness: true
  
  validates :sconto_fattura, length: { maximum: 100 }, allow_blank: true
  validates :data_inizio_lavori, length: { maximum: 100 }, allow_blank: true
  validates :data_fine_lavori, length: { maximum: 100 }, allow_blank: true
  validates :finiture_estetiche, length: { maximum: 100 }, allow_blank: true
  validates :rilievi_definitivi, length: { maximum: 100 }, allow_blank: true
  validates :copia_chiavi, length: { maximum: 100 }, allow_blank: true
  validates :sopralluogo, length: { maximum: 100 }, allow_blank: true
  validates :autorizzazione_comunale, length: { maximum: 100 }, allow_blank: true
  validates :ordine_struttura, length: { maximum: 100 }, allow_blank: true
  validates :consegna_struttura, length: { maximum: 100 }, allow_blank: true
  validates :ordine_materiale, length: { maximum: 100 }, allow_blank: true
  validates :consegna_materiale, length: { maximum: 100 }, allow_blank: true
  validates :ordine_montaggio, length: { maximum: 100 }, allow_blank: true
  validates :ordine_opere, length: { maximum: 100 }, allow_blank: true
  validates :ponteggio, length: { maximum: 100 }, allow_blank: true
  validates :ordine_serramenti, length: { maximum: 100 }, allow_blank: true
  validates :ordine_lavorazioni, length: { maximum: 100 }, allow_blank: true
  validates :spostamento_tubazioni, length: { maximum: 100 }, allow_blank: true
  validates :disegno_definitivo, length: { maximum: 100 }, allow_blank: true
  validates :dichiarazione_strutture, length: { maximum: 100 }, allow_blank: true
  validates :dichiarazione_assorbimenti, length: { maximum: 100 }, allow_blank: true
  validates :schema_elettrico, length: { maximum: 100 }, allow_blank: true
  validates :ampliamento_contatore, length: { maximum: 100 }, allow_blank: true
  validates :approvazione_disegno_cliente, length: { maximum: 100 }, allow_blank: true

  def self.for_project(project)
    find_or_initialize_by(project: project)
  end
end