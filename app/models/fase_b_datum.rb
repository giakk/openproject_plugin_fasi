class FaseBDatum < ApplicationRecord
  belongs_to :project

  validates :project_id, uniqueness: true

  validates :fossa_ridotta, length: { maximum: 100 }, allow_blank: true
  validates :notifica_asl, length: { maximum: 100 }, allow_blank: true
  validates :coordinamento_sicurezza, length: { maximum: 100 }, allow_blank: true
  validates :cartello_di_cantiere, length: { maximum: 100 }, allow_blank: true
  validates :autorizzazione_subappalto, length: { maximum: 100 }, allow_blank: true
  validates :consegna_doc_sicurezza, length: { maximum: 100 }, allow_blank: true
  validates :prove_materiali, length: { maximum: 100 }, allow_blank: true
  validates :consegna_cliente, length: { maximum: 100 }, allow_blank: true
  validates :verbale_consegna, length: { maximum: 100 }, allow_blank: true

  def self.for_project(project)
    find_or_initialize_by(project: project)
  end
end