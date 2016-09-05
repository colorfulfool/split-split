class SplitTestResults
  def initialize(experiment, start: nil, finish: nil)
    @experiment = experiment
    @start = start || 'Visited landing page'
    @finish = finish || 'Signed up'
  end

  def success_rates
    rates = {}
    distribution_on_stage(@start).each do |variant, subjects_visited|
      subjects_acted = distribution_on_stage(@finish)[variant] || 0
      rates[variant] = subjects_acted.to_f / subjects_visited * 100
    end
    rates
  end

  def distribution_on_stage(goal)
    Ahoy::Event.this_week.where(name: goal).group("properties -> 'variant' ->> '#{@experiment}'").count.except(nil)
  end
end