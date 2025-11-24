class CreateFaseAData < ActiveRecord::Migration[7.1]
  def change
    create_table :fase_a_data do |t|
      t.references :project, null: false, foreign_key: true, index: { unique: true }
      
      t.string :sconto_fattura, limit: 100
      t.string :data_inizio_lavori, limit: 100
      t.string :data_fine_lavori, limit: 100
      t.string :finiture_estetiche, limit: 100
      t.string :rilievi_definitivi, limit: 100
      t.string :copia_chiavi, limit: 100
      t.string :sopralluogo, limit: 100
      t.string :autorizzazione_comunale, limit: 100
      t.string :ordine_struttura, limit: 100
      t.string :consegna_struttura, limit: 100
      t.string :ordine_materiale, limit: 100
      t.string :consegna_materiale, limit: 100
      t.string :ordine_montaggio, limit: 100
      t.string :ordine_opere, limit: 100
      t.string :ponteggio, limit: 100
      t.string :ordine_serramenti, limit: 100
      t.string :ordine_lavorazioni, limit: 100
      t.string :spostamento_tubazioni, limit: 100
      t.string :disegno_definitivo, limit: 100
      t.string :dichiarazione_strutture, limit: 100
      t.string :dichiarazione_assorbimenti, limit: 100
      t.string :schema_elettrico, limit: 100
      t.string :ampliamento_contatore, limit: 100
      t.string :approvazione_disegno_cliente, limit: 100
      t.boolean :hide, default: false

      t.timestamps
    end
  end
end