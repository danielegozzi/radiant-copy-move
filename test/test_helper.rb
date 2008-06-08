# Load the the environment
unless defined? RADIANT_ROOT
  ENV["RAILS_ENV"] = "test"
  require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/environment"
end
require "#{RADIANT_ROOT}/test/test_helper"
require 'digest/sha1'

class Test::Unit::TestCase
  
  # Include a helper to make testing Radius tags easier
  test_helper :extension_tags
  
  # Add the fixture directory to the fixture path
  self.fixture_path << File.dirname(__FILE__) + "/fixtures"

  # exports page structure as an easily comparable hash
  def page_structure(page)
    {:slug => page.slug, :children => page.children.sort{|c1, c2| c1.slug <=> c2.slug}.map{|c| page_structure(c)}}
  end

  # Add more helper methods to be used by all extension tests here...
  
  def assert_difference(object, method = nil, difference = 1)
    initial_value = object.send(method)
    yield
    assert_equal initial_value + difference, object.send(method), "#{object}##{method}"
  end
  
  def assert_no_difference(object, method, &block)
    assert_difference object, method, 0, &block
  end
end
