class PagesController < ApplicationController
  def index
  end

  def error
    raise ArgumentError
  end

  def test_throttle
  end
end
