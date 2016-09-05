# Split-Split

Split-Split is a **tiny A/B testing framework** for Rails.

Set up an experiment.
```erb
<% split_test :welcome_speech, [:rich, :consise] do |variant| %>
  <h2><%= t("welcome_speech.#{variant}") %></h2>
<% end %>
```

Visualize the results.
```erb
<%= pie_chart SplitTestResults.new(:welcome_speech).success_rates %>
```

## Installation

Visitor tracking is provided by [Ahoy](https://github.com/ankane/ahoy). If you want to chart the results like in example above, install [Chartkick](https://github.com/ankane/chartkick) gem.

```ruby
gem 'split_split'
```

## Usage

Let's say, we've made two versions of our landing page and can't decide which one is better.

### 1. Collect the data

We've put our two versions into separate files: `landing_page_visual.html.erb` and `landing_page_textual.html.erb`. Head into the controller action that renders the landing page and insert `split_test` there.

```ruby
def landing_page
  split_test :landing_page, [:visual, :textual] do |variant|
    render "landing_page_#{variant}"
  end
end
```

### 2. Visualize results

Wherever you want to display results, write this:

```erb
<h2>Landing pages comparsion</h2>
<% SplitTestResults.new(:landing_page).success_rates.each do |variant, rate| %>
  <%= variant %> --> <%= "#{rate.to_i}%" %>
<% end %>
```

It assumes that each visit was tracked as an `Ahoy::Event` named `Visited landing page` and each sign-up named `Signed up`. If you need to track different events, specify them:

```ruby
SplitTestResults.new(:landing_page, start: 'Visited', finish: 'Purchased').success_rates
```