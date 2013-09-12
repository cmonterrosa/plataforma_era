# config/initializers/pdfkit.rb
PDFKit.configure do |config|
  config.default_options = {
    :page_size => 'letter',
    :margin_top => '0.5in',
    :margin_right => '0.45in',
    :margin_bottom => '0.5in',
    :margin_left => '0.45in',
    :encoding => 'UTF-8',
    :print_media_type => true
  }
end
