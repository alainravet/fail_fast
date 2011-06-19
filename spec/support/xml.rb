
def evaluate_xml_erb(template)
  ERB.new(File.read(template)).result(binding).gsub(/[\t\r\n]/, '')
end
