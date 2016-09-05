# Split-Split

Split-Split is a **tiny A/B testing framework**. It relies on Ahoy for visitor tracking.

## Usage

Let's say, we've made two versions of our landing page and we can't decide which one is better.

### 1. Collect the data

We put our two versions into separate files: `landing_page_visual.html.erb` and `landing_page_textual.html.erb`. Head into the controller action that renders the landing page and insert `split_test` there.

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