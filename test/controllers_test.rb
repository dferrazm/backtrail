require 'test_helper'
require 'action_controller'
require 'backtrail/controllers'

class FooController < ActionController::Base
  include Backtrail::BaseController
end

class ControllersTest < ActionController::TestCase

  # returns the default path when the paths's stack is nil
  def test_previous_path_when_stack_is_nil
    controller = new_controller
    assert_equal '/root_path', controller.previous_path
  end

  # returns the root path when the paths's stack is empty
  def test_previous_path_when_stack_is_empty
    controller = new_controller previous_paths: []
    assert_equal '/root_path', controller.previous_path
  end

  # holds only the last 5 requests paths
  def test_update_previous_paths_max_storage
    controller = new_controller

    paths = (1..7).map { |i| "/path#{i}" }
    trail controller, paths

    assert_equal 5, controller.session['previous_paths'].length
  end

  # does not save the previous path when referrer equals to the current
  def test_when_referrer_equals_to_current
    controller = new_controller
    fake_request controller, "/same_path", "/same_path"
    assert_equal 0, controller.session['previous_paths'].length
  end

  # returns the top path from the stack when going forward
  def test_when_going_forward
    controller = new_controller
    trail controller, ['/path1', '/path2']

    assert_equal '/path1', controller.previous_path
    assert_equal 1, controller.session['previous_paths'].length
  end

  # pops the top path and returns the former when going back
  def test_when_going_backwards
    controller = new_controller
    trail controller, ['/path1', '/path2', '/path3']
    go_back controller, '/path2'

    assert_equal '/path1', controller.previous_path
    assert_equal 1, controller.session['previous_paths'].length
  end

  # does not save the path on non GET requests
  def test_on_non_get_requests
    controller = new_controller
    fake_request controller, '/path1', '/referrer', get?: false
    assert_equal nil, controller.session['previous_paths']
  end

  # does not save the path when on async request
  def test_on_async_requests
    controller = new_controller
    fake_request controller, '/path1', '/referrer', xhr?: true
    assert_equal nil, controller.session['previous_paths']
  end

  # does not save the path when there's no referer
  def test_on_non_referrer_requests
    controller = new_controller
    fake_request controller, '/path1', nil
    assert_equal nil, controller.session['previous_paths']
  end

  # does not save the path when going back
  def test_on_back_requests
    controller = new_controller
    go_back controller, '/path1'
    assert_equal nil, controller.session['previous_paths']
  end

  # does not save the referer on async request
  def test_referrer_on_async_requests
    controller = new_controller
    fake_request controller, '/path1', nil, xhr?: true
    assert_equal nil, controller.session['_referer']
  end

  # does not save the referer on non GET method
  def test_referrer_on_non_get_requests
    controller = new_controller
    fake_request controller, '/path1', nil, get?: false
    assert_equal nil, controller.session['_referer']
  end

  private

  def new_controller(params = {})
    controller = FooController.new
    controller.stubs(:params).returns Hash.new
    controller.stubs(:session).returns({'previous_paths' => params[:previous_paths]})
    controller.stubs(:root_path).returns '/root_path'
    request = mock 'object'
    controller.stubs(:request).returns request

    controller
  end

  def trail(controller, path_trail)
    referrer = nil

    path_trail.each do |path|
      fake_request controller, path, referrer
      referrer = path
    end
  end

  def fake_request(controller, path, referrer, options = {})
    controller.request.stubs(:get?).returns(options[:get?].nil? ? true : options[:get?])
    controller.request.stubs(:xhr?).returns(options[:xhr?] || false)
    controller.request.stubs(:url).returns path
    controller.session['_referer'] = referrer
    controller.send :update_previous_paths
  end

  def go_back(controller, path)
    controller.params[:trail] = 'back'
    trail controller, [path]
  end
end
