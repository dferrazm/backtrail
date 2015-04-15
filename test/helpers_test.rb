require 'test_helper'
require 'action_view/test_case'
require 'backtrail/helpers'

class HelpersTest < ActionView::TestCase
  include Backtrail::ViewHelpers

  def test_backtrail_link
    self.stubs(:previous_path).returns '/previous'
    assert_equal '<a class="backtrail" href="/previous?trail=back">Back</a>', backtrail
  end
end
