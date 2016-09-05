module SplitTesting
  extend ActiveSupport::Concern

  included do
    helper_method :split_test
  end

  def split_test(experiment, variants)
    current_variant = cookies["#{experiment}_variant"] || variants.sample
    cookies.permanent["#{experiment}_variant"] = current_variant
  	yield current_variant
  end
end