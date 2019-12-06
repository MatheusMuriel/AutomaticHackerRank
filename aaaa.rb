require 'httparty'
require 'zip'

regex_url = /^(http(s)?:\/\/www\.hackerrank\.com\/challenges\/){1}([a-zA-Z]|[0-9])+(\-([a-zA-Z]|[0-9])+)*\/(problem$)?/

#puts "Bem vindo ao automatizador de desafios do HackerRank :D"

#puts "Qual é o link do desafio que vc deseja?"

url = gets

if !url.match(regex_url)
    puts "Url invalida"
    exit
end

url = url.gsub(/\s|\n/, '').gsub(/\/problem$|\/problem\/$/, '')

# Download test cases
url_testecase = url.gsub(/\/challenges\//, '/rest/contests/master/challenges/') + "/download_testcases"

zip_file = HTTParty.get(url_testecase).body
Zip::InputStream.open(StringIO.new(zip_file)) do |io|
    while entry = io.get_next_entry
      file_path = File.join(Dir.pwd, entry.name)
      FileUtils.mkdir_p(File.dirname(file_path))
      entry.extract(file_path) unless File.exist?(file_path)
    end
  end