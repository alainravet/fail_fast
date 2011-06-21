
def evaluate_xml_erb(template, remove_tabs_and_eol=true)
  res = ERB.new(File.read(template)).result(binding)
  res.gsub!(/[\t\r\n]/, '') if remove_tabs_and_eol
  res
end
