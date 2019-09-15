class ChangeLibraryTypeColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :libraries, :type, :librarytype
  end
end
