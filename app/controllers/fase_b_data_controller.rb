class FaseBDataController < ApplicationController
  # Usa il sistema di autorizzazione nativo di OpenProject
  before_action :find_project_by_project_id
  before_action :authorize
  before_action :find_or_initialize_fase_b_datum

  def show
    respond_to do |format|
      format.html
      format.json { render json: fase_b_datum_representer, status: :ok }
    end
  end

  def update
    if @fase_b_datum.update(permitted_params)
      render json: fase_b_datum_representer, status: :ok
    else
      render json: { errors: @fase_b_datum.errors.full_messages }, 
             status: :unprocessable_entity
    end
  end

  private

  def find_or_initialize_fase_b_datum
    @fase_b_datum = FaseBDatum.for_project(@project)
  end

  def fase_b_datum_representer
    {
      project_id: @fase_b_datum.project_id,
      fossa_ridotta: @fase_b_datum.fossa_ridotta,
      notifica_asl: @fase_b_datum.notifica_asl,
      coordinamento_sicurezza: @fase_b_datum.coordinamento_sicurezza,
      cartello_di_cantiere: @fase_b_datum.cartello_di_cantiere,
      autorizzazione_subappalto: @fase_b_datum.autorizzazione_subappalto,
      consegna_doc_sicurezza: @fase_b_datum.consegna_doc_sicurezza,
      prove_materiali: @fase_b_datum.prove_materiali,
      consegna_cliente: @fase_b_datum.consegna_cliente,
      verbale_consegna: @fase_b_datum.verbale_consegna,
      hide: @fase_b_datum.hide,
      created_at: @fase_b_datum.created_at,
      updated_at: @fase_b_datum.updated_at
    }
  end

  def permitted_params
    params.require(:fase_b_datum).permit(
      :fossa_ridotta,
      :notifica_asl,
      :coordinamento_sicurezza,
      :cartello_di_cantiere,
      :autorizzazione_subappalto,
      :consegna_doc_sicurezza,
      :prove_materiali,
      :consegna_cliente,
      :verbale_consegna,
      :hide
    )
  end
end