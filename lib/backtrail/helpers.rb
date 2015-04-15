module Backtrail
  module ViewHelpers
    def backtrail
      link_to 'Back', "#{previous_path}?trail=back", class: 'backtrail'
    end
  end
end
