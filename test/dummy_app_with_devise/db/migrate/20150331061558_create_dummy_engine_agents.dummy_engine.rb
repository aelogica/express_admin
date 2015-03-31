# This migration comes from dummy_engine (originally 20150331025419)
class CreateDummyEngineAgents < ActiveRecord::Migration
  def change
    create_table :dummy_engine_agents do |t|
      t.string :last_name
      t.string :first_name
    end
  end
end
