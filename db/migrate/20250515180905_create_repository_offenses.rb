class CreateRepositoryOffenses < ActiveRecord::Migration[7.2]
  def change
    create_table :repository_offenses do |t|
      t.references :check, null: false, foreign_key: { to_table: :repository_checks }, index: true
      t.string :file_path
      t.string :cop_name
      t.string :message
      t.string :position

      t.timestamps
    end
  end
end
