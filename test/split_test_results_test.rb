require 'minitest/autorun'
require 'active_record'
require 'byebug'

require 'split_test_results'

ActiveRecord::Base.establish_connection adapter: "postgresql", database: "ahoy_test"

ActiveRecord::Migration.create_table :ahoy_events, force: true do |t|
  t.json :properties
  t.string :name
end

module Ahoy
  class Event < ActiveRecord::Base
    # include Ahoy::Properties
    self.table_name = "ahoy_events"
  end
end

describe SplitTestResults do
  before do
    [
      'Visited landing page', {:landing_page => 'visual'},
      'Visited landing page', {:landing_page => 'visual'},
      'Visited landing page', {:landing_page => 'visual'},
      'Visited landing page', {:landing_page => 'visual'},
      'Signed up', {:landing_page => 'visual'},
      'Visited landing page', {:landing_page => 'textual'},
      'Visited landing page', {:landing_page => 'textual'},
      'Visited landing page', {:landing_page => 'textual'},
      'Visited landing page', {:landing_page => 'textual'},
      'Signed up', {:landing_page => 'textual'},
      'Signed up', {:landing_page => 'textual'}
    ].each_slice(2) do |name, variant|
      Ahoy::Event.create(name: name, properties: {variant: variant})
    end
  end

  it 'success_rates' do
    results = SplitTestResults.new(:landing_page).success_rates

    assert_equal 25, results['visual']
    assert_equal 50, results['textual']
  end
end