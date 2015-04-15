module MyGem
  class Railtie < Rails::Railtie
    initializer "backtrail.view_helpers" do
      ActionView::Base.send :include, Backtrail::ViewHelpers
    end
  end
end
