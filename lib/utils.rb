def tempfile
  File.join(Rails.root, "tmp", "#{Time.now.to_f}-#{rand(1000000)}")
end

def combined_pdf_files(files)
  combined_pdf_file = "#{tempfile}.pdf"
  require 'pdf_merger'
  PdfMerger.new.merge(files, combined_pdf_file)
  combined_pdf_file
end
