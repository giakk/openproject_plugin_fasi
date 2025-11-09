class CreateFaseCData < ActiveRecord::Migration[7.1]
  def change
    create_table :fase_c_data do |t|
      t.references :project, null: false, foreign_key: true, index: { unique: true }
      
      t.string :collaudo_impianto, limit: 100
      t.string :libretto_impianto, limit: 100
      t.string :dichiarazione_ce, limit: 100
      t.string :contratto_manutenzione, limit: 100
      t.string :incarico_ente_certificato, limit: 100
      t.string :numero_matricola, limit: 100
      t.string :fine_lavori_pratica, limit: 100
      t.string :variazione_catastale, limit: 100

      t.timestamps
    end
  end
end