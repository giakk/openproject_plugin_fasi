class CreateFaseBData < ActiveRecord::Migration[7.1]
  def change
    create_table :fase_b_data do |t|
      t.references :project, null: false, foreign_key: true, index: { unique: true }
      
      t.string :fossa_ridotta, limit: 100
      t.string :notifica_asl, limit: 100
      t.string :coordinamento_sicurezza, limit: 100
      t.string :cartello_di_cantiere, limit: 100
      t.string :autorizzazione_subappalto, limit: 100
      t.string :consegna_doc_sicurezza, limit: 100
      t.string :prove_materiali, limit: 100
      t.string :consegna_cliente, limit: 100
      t.string :verbale_consegna, limit: 100

      t.timestamps
    end
  end
end