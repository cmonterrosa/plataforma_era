PDFKit.configure do |config|
  config.default_options = {
    :page_size => 'letter',
    :margin_top => '0.5in',
    :margin_right => '0.45in',
    :margin_bottom => '0.5in',
    :margin_left => '0.45in',
    :encoding => 'utf-8',
    :header_right => "Fecha de creación: [date] [time]     ",
    :footer_right => "Página [page] de [toPage]     "
  }
end
