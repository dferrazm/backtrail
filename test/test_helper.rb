require 'bundler/setup'
require 'active_support'
require 'minitest'
require 'minitest/autorun'
require 'minitest/unit'
require 'mocha/mini_test'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

Minitest::Test = Minitest::Unit::TestCase unless defined?(Minitest::Test)

# Filter out Minitest backtrace while allowing backtrace  from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

ActiveSupport::TestCase.test_order = :random
