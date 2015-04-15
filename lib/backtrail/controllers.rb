module Backtrail
  module BaseController
    extend ActiveSupport::Concern

    included do
      before_action :update_previous_paths
      helper_method :previous_path
    end

    def previous_path
      get_from_stack_path || backtrail_starting_point
    end

    protected

    def update_previous_paths
      current = request.url.split('?')[0]
      if request.get? and !request.xhr?
        if session['_referer'].present? and !params[:trail]
          previous = session['_referer']
          if session['previous_paths'].nil?
            session['previous_paths'] = []
          end
          if session['previous_paths'].length == 5
            session['previous_paths'].delete_at 0
          end
          if previous != current
            session['previous_paths'].push previous
          end
        end
        session['_referer'] = current
      end
    end

    def get_from_stack_path
      if params[:trail] == 'back'
        session['previous_paths'].try(:pop)
      end
      session['previous_paths'].try(:last)
    end

    def backtrail_starting_point
      root_path
    end
  end
end
