class CreateAgendas < ActiveRecord::Migration[6.0]
  def change
    create_table :agendas do |t|
      t.string :name, null: false
      t.text :content
      t.integer :position, null: false
      t.references :room, null: false, foreign_key: true
      t.timestamps
    end
  end
end
