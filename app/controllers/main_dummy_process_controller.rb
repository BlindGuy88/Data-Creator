class MainDummyProcessController < ApplicationController
  include CSharpParser

  def show
      put_two_as_return
  end

  def get_code_field
      #respond_to do |format|
      #  format.html
      #
      #  format.json {render:json => {"data" => "{'name':'randy','type':'number','length':'100','theme':'age'}"}.to_json}
      #end


    json = "halo"
    respond_to do |format|
      format.json {render :json => {"data" => "randy"}.to_json}
      format.html {render :json => {"data" => "randy"}.to_json}
    end


  end

end
