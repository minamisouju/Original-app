class CreateContents < ActiveRecord::Migration[5.2]
  def change
    create_table :contents do |t|
      t.text :original_text
      t.text :converted_text

      t.timestamps
    end
  end
end
