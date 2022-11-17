class CreateCheckBoxes < ActiveRecord::Migration[6.1]
  def change
    create_table :check_boxes do |t|
      t.string :title_of_reason
      t.text :description_of_reason
      t.references :survey_question, foreign_key: true
      t.timestamps
    end
  end
end
