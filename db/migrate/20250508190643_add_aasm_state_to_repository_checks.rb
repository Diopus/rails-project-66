class AddAasmStateToRepositoryChecks < ActiveRecord::Migration[7.2]
  def change
    add_column :repository_checks, :aasm_state, :string
  end
end
