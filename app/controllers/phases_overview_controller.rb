class PhasesOverviewController < ApplicationController
  before_action :authorize
  
  def index
    respond_to do |format|
      format.html
      format.json { render json: phases_data, status: :ok }
    end
  end

  def update
    phase_type = params[:phase_type]
    project_id = params[:project_id]
    field_name = params[:field_name]
    value = params[:value]

    project = Project.find_by(id: project_id)
    
    unless project
      render json: { error: 'Project not found' }, status: :not_found
      return
    end

    phase_datum = find_or_initialize_phase_datum(phase_type, project)
    
    if phase_datum.update(field_name => value)
      render json: { success: true, value: value }, status: :ok
    else
      render json: { 
        error: 'Update failed', 
        messages: phase_datum.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  private

  def phases_data
    # Ottiene solo i progetti attivi
    active_projects = Project.where(active: true).order(:name)
    
    projects_data = active_projects.map do |project|
      fase_a = FaseADatum.find_or_initialize_by(project: project)
      fase_b = FaseBDatum.find_or_initialize_by(project: project)
      fase_c = FaseCDatum.find_or_initialize_by(project: project)

      # Recupera il custom field "Indirizzo Impianto"
      indirizzo_impianto_cf = ProjectCustomField.find_by(name: 'Indirizzo Impianto')
      indirizzo_impianto_value = nil
      if indirizzo_impianto_cf
        custom_value = project.custom_value_for(indirizzo_impianto_cf)
        indirizzo_impianto_value = custom_value&.value
      end

      {
        project_id: project.id,
        project_name: project.name,
        project_identifier: project.identifier,
        indirizzo_impianto: indirizzo_impianto_value,
        fase_a: serialize_fase_a(fase_a),
        fase_b: serialize_fase_b(fase_b),
        fase_c: serialize_fase_c(fase_c)
      }
    end

    {
      projects: projects_data,
      columns: {
        fase_a: fase_a_columns,
        fase_b: fase_b_columns,
        fase_c: fase_c_columns
      }
    }
  end

  def serialize_fase_a(fase_a)
    {
      sconto_fattura: fase_a.sconto_fattura,
      data_inizio_lavori: fase_a.data_inizio_lavori,
      data_fine_lavori: fase_a.data_fine_lavori,
      finiture_estetiche: fase_a.finiture_estetiche,
      rilievi_definitivi: fase_a.rilievi_definitivi,
      copia_chiavi: fase_a.copia_chiavi,
      sopralluogo: fase_a.sopralluogo,
      autorizzazione_comunale: fase_a.autorizzazione_comunale,
      ordine_struttura: fase_a.ordine_struttura,
      consegna_struttura: fase_a.consegna_struttura,
      ordine_materiale: fase_a.ordine_materiale,
      consegna_materiale: fase_a.consegna_materiale,
      ordine_montaggio: fase_a.ordine_montaggio,
      ordine_opere: fase_a.ordine_opere,
      ponteggio: fase_a.ponteggio,
      ordine_serramenti: fase_a.ordine_serramenti,
      ordine_lavorazioni: fase_a.ordine_lavorazioni,
      spostamento_tubazioni: fase_a.spostamento_tubazioni,
      disegno_definitivo: fase_a.disegno_definitivo,
      dichiarazione_strutture: fase_a.dichiarazione_strutture,
      dichiarazione_assorbimenti: fase_a.dichiarazione_assorbimenti,
      schema_elettrico: fase_a.schema_elettrico,
      ampliamento_contatore: fase_a.ampliamento_contatore,
      approvazione_disegno_cliente: fase_a.approvazione_disegno_cliente
    }
  end

  def serialize_fase_b(fase_b)
    {
      fossa_ridotta: fase_b.fossa_ridotta,
      notifica_asl: fase_b.notifica_asl,
      coordinamento_sicurezza: fase_b.coordinamento_sicurezza,
      cartello_di_cantiere: fase_b.cartello_di_cantiere,
      autorizzazione_subappalto: fase_b.autorizzazione_subappalto,
      consegna_doc_sicurezza: fase_b.consegna_doc_sicurezza,
      prove_materiali: fase_b.prove_materiali,
      consegna_cliente: fase_b.consegna_cliente,
      verbale_consegna: fase_b.verbale_consegna
    }
  end

  def serialize_fase_c(fase_c)
    {
      collaudo_impianto: fase_c.collaudo_impianto,
      libretto_impianto: fase_c.libretto_impianto,
      dichiarazione_ce: fase_c.dichiarazione_ce,
      contratto_manutenzione: fase_c.contratto_manutenzione,
      incarico_ente_certificato: fase_c.incarico_ente_certificato,
      numero_matricola: fase_c.numero_matricola,
      fine_lavori_pratica: fase_c.fine_lavori_pratica,
      variazione_catastale: fase_c.variazione_catastale
    }
  end

  def fase_a_columns
    [
      { key: 'sconto_fattura', label: 'fase_a.sconto_fattura' },
      { key: 'data_inizio_lavori', label: 'fase_a.data_inizio_lavori' },
      { key: 'data_fine_lavori', label: 'fase_a.data_fine_lavori' },
      { key: 'finiture_estetiche', label: 'fase_a.finiture_estetiche' },
      { key: 'rilievi_definitivi', label: 'fase_a.rilievi_definitivi' },
      { key: 'copia_chiavi', label: 'fase_a.copia_chiavi' },
      { key: 'sopralluogo', label: 'fase_a.sopralluogo' },
      { key: 'autorizzazione_comunale', label: 'fase_a.autorizzazione_comunale' },
      { key: 'ordine_struttura', label: 'fase_a.ordine_struttura' },
      { key: 'consegna_struttura', label: 'fase_a.consegna_struttura' },
      { key: 'ordine_materiale', label: 'fase_a.ordine_materiale' },
      { key: 'consegna_materiale', label: 'fase_a.consegna_materiale' },
      { key: 'ordine_montaggio', label: 'fase_a.ordine_montaggio' },
      { key: 'ordine_opere', label: 'fase_a.ordine_opere' },
      { key: 'ponteggio', label: 'fase_a.ponteggio' },
      { key: 'ordine_serramenti', label: 'fase_a.ordine_serramenti' },
      { key: 'ordine_lavorazioni', label: 'fase_a.ordine_lavorazioni' },
      { key: 'spostamento_tubazioni', label: 'fase_a.spostamento_tubazioni' },
      { key: 'disegno_definitivo', label: 'fase_a.disegno_definitivo' },
      { key: 'dichiarazione_strutture', label: 'fase_a.dichiarazione_strutture' },
      { key: 'dichiarazione_assorbimenti', label: 'fase_a.dichiarazione_assorbimenti' },
      { key: 'schema_elettrico', label: 'fase_a.schema_elettrico' },
      { key: 'ampliamento_contatore', label: 'fase_a.ampliamento_contatore' },
      { key: 'approvazione_disegno_cliente', label: 'fase_a.approvazione_disegno_cliente' }
    ]
  end

  def fase_b_columns
    [
      { key: 'fossa_ridotta', label: 'fase_b.fossa_ridotta' },
      { key: 'notifica_asl', label: 'fase_b.notifica_asl' },
      { key: 'coordinamento_sicurezza', label: 'fase_b.coordinamento_sicurezza' },
      { key: 'cartello_di_cantiere', label: 'fase_b.cartello_di_cantiere' },
      { key: 'autorizzazione_subappalto', label: 'fase_b.autorizzazione_subappalto' },
      { key: 'consegna_doc_sicurezza', label: 'fase_b.consegna_doc_sicurezza' },
      { key: 'prove_materiali', label: 'fase_b.prove_materiali' },
      { key: 'consegna_cliente', label: 'fase_b.consegna_cliente' },
      { key: 'verbale_consegna', label: 'fase_b.verbale_consegna' }
    ]
  end

  def fase_c_columns
    [
      { key: 'collaudo_impianto', label: 'fase_c.collaudo_impianto' },
      { key: 'libretto_impianto', label: 'fase_c.libretto_impianto' },
      { key: 'dichiarazione_ce', label: 'fase_c.dichiarazione_ce' },
      { key: 'contratto_manutenzione', label: 'fase_c.contratto_manutenzione' },
      { key: 'incarico_ente_certificato', label: 'fase_c.incarico_ente_certificato' },
      { key: 'numero_matricola', label: 'fase_c.numero_matricola' },
      { key: 'fine_lavori_pratica', label: 'fase_c.fine_lavori_pratica' },
      { key: 'variazione_catastale', label: 'fase_c.variazione_catastale' }
    ]
  end

  def find_or_initialize_phase_datum(phase_type, project)
    case phase_type
    when 'fase_a'
      FaseADatum.find_or_initialize_by(project: project)
    when 'fase_b'
      FaseBDatum.find_or_initialize_by(project: project)
    when 'fase_c'
      FaseCDatum.find_or_initialize_by(project: project)
    else
      raise "Unknown phase type: #{phase_type}"
    end
  end
end
