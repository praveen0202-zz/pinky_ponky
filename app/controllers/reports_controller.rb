class ReportsController < ApplicationController

  respond_to :pdf

  def read_generated_pdf
    # File name contains . so it's treating after . as format.
    send_data  File.open("#{Rails.root}/tmp/" + params[:file_name] + '.' + params[:format] + ".pdf").read, :type => Mime::PDF,
              :disposition => 'inline'
  end
  
end
