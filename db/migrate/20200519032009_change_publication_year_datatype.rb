class ChangePublicationYearDatatype < ActiveRecord::Migration[6.0]
  def change
    change_column :works, :publication_year, 'integer USING CAST(publication_year AS integer)' # could not do a simple conversion, needed to specify how I wanted the previous string datatype converted to integer (source: https://makandracards.com/makandra/18691-postgresql-vs-rails-migration-how-to-change-columns-from-string-to-integer)
  end
end
