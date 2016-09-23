class ChangeDefaultOnOutstandingAndActor < ActiveRecord::Migration[5.0]
  def change
    change_column_default :videos, :outstanding, from: false, to: true
    change_column_default :show_person_roles, :actor, from: false, to: true
  end
end
