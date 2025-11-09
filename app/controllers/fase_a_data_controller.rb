class FaseADataController < ApplicationController
  # Usa il sistema di autorizzazione nativo di OpenProject
  before_action :find_project_by_project_id
  before_action :authorize
  before_action :find_or_initialize_fase_a_datum

  def show
    respond_to do |format|
      format.html
      format.json { render json: fase_a_datum_representer, status: :ok }
    end
  end

  def update
    if @fase_a_datum.update(permitted_params)
      render json: fase_a_datum_representer, status: :ok
    else
      render json: { errors: @fase_a_datum.errors.full_messages }, 
             status: :unprocessable_entity
    end
  end

  private

  def find_or_initialize_fase_a_datum
    @fase_a_datum = FaseADatum.for_project(@project)
  end

  #TODO: To be modified
  def fase_a_datum_representer
    {
      project_id: @fase_a_datum.project_id,
      sconto_fattura: @fase_a_datum.sconto_fattura,
      data_inizio_lavori: @fase_a_datum.data_inizio_lavori,
      data_fine_lavori: @fase_a_datum.data_fine_lavori,
      finiture_estetiche: @fase_a_datum.finiture_estetiche,
      rilievi_definitivi: @fase_a_datum.rilievi_definitivi,
      copia_chiavi: @fase_a_datum.copia_chiavi,
      sopralluogo: @fase_a_datum.sopralluogo,
      autorizzazione_comunale: @fase_a_datum.autorizzazione_comunale,
      ordine_struttura: @fase_a_datum.ordine_struttura,
      consegna_struttura: @fase_a_datum.consegna_struttura,
      ordine_materiale: @fase_a_datum.ordine_materiale,
      consegna_materiale: @fase_a_datum.consegna_materiale,
      ordine_montaggio: @fase_a_datum.ordine_montaggio,
      ordine_opere: @fase_a_datum.ordine_opere,
      ponteggio: @fase_a_datum.ponteggio,
      ordine_serramenti: @fase_a_datum.ordine_serramenti,
      spostamento_tubazioni: @fase_a_datum.spostamento_tubazioni,
      disegno_definitivo: @fase_a_datum.disegno_definitivo,
      dichiarazione_strutture: @fase_a_datum.dichiarazione_strutture,
      dichiarazione_assorbimenti: @fase_a_datum.dichiarazione_assorbimenti,
      schema_elettrico: @fase_a_datum.schema_elettrico,
      ampliamento_contatore: @fase_a_datum.ampliamento_contatore,
      approvazione_disegno_cliente: @fase_a_datum.approvazione_disegno_cliente,
      created_at: @fase_a_datum.created_at,
      updated_at: @fase_a_datum.updated_at
    }
  end

  def permitted_params
    params.require(:fase_a_datum).permit(
      :sconto_fattura,
      :data_inizio_lavori,
      :data_fine_lavori,
      :finiture_estetiche,
      :rilievi_definitivi,
      :copia_chiavi,
      :sopralluogo,
      :autorizzazione_comunale,
      :ordine_struttura,
      :consegna_struttura,
      :ordine_materiale,
      :consegna_materiale,
      :ordine_montaggio,
      :ordine_opere,
      :ponteggio,
      :ordine_serramenti,
      :spostamento_tubazioni,
      :disegno_definitivo,
      :dichiarazione_strutture,
      :dichiarazione_assorbimenti,
      :schema_elettrico,
      :ampliamento_contatore,
      :approvazione_disegno_cliente
    )
  end
end