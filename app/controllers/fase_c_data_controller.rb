class FaseCDataController < ApplicationController
  # Usa il sistema di autorizzazione nativo di OpenProject
  before_action :find_project_by_project_id
  before_action :authorize
  before_action :find_or_initialize_fase_c_datum

  def show
    respond_to do |format|
      format.html
      format.json { render json: fase_c_datum_representer, status: :ok }
    end
  end

  def update
    if @fase_c_datum.update(permitted_params)
      render json: fase_c_datum_representer, status: :ok
    else
      render json: { errors: @fase_c_datum.errors.full_messages }, 
             status: :unprocessable_entity
    end
  end

  private

  def find_or_initialize_fase_c_datum
    @fase_c_datum = FaseCDatum.for_project(@project)
  end

  def fase_c_datum_representer
    {
      project_id: @fase_c_datum.project_id,
      collaudo_impianto: @fase_c_datum.collaudo_impianto,
      libretto_impianto: @fase_c_datum.libretto_impianto,
      dichiarazione_ce: @fase_c_datum.dichiarazione_ce,
      contratto_manutenzione: @fase_c_datum.contratto_manutenzione,
      incarico_ente_certificato: @fase_c_datum.incarico_ente_certificato,
      numero_matricola: @fase_c_datum.numero_matricola,
      fine_lavori_pratica: @fase_c_datum.fine_lavori_pratica,
      variazione_catastale: @fase_c_datum.variazione_catastale,
      hide: @fase_c_datum.hide,
      created_at: @fase_c_datum.created_at,
      updated_at: @fase_c_datum.updated_at
    }
  end

  def permitted_params
    params.require(:fase_c_datum).permit(
      :collaudo_impianto,
      :libretto_impianto,
      :dichiarazione_ce,
      :contratto_manutenzione,
      :incarico_ente_certificato,
      :numero_matricola,
      :fine_lavori_pratica,
      :variazione_catastale,
      :hide
    )
  end
end