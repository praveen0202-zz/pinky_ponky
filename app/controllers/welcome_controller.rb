class WelcomeController < ApplicationController
  layout "application"

  def index
    render :inline => "<%= netzke :application %>", :layout => true
  end
    
end
