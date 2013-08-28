class MainDummyProcessController < ApplicationController
  include CSharpParser

  def show
      put_two_as_return
  end
end
