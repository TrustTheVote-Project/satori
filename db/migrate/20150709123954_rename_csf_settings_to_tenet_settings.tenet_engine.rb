# This migration comes from tenet_engine (originally 20141113052423)
class RenameCsfSettingsToTenetSettings < ActiveRecord::Migration
  def change
    rename_table :csf_settings, :tenet_settings
  end
end
