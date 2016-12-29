system("clear")

require "ohanakapa"
require "sinatra"
require "sinatra/reloader" if development?

# ===========================

get "/" do
    erb(:search)
end

get "/org_search" do # form method=GET => /org_search?search_terms
    
    Ohanakapa.configure do |config|
        config.api_token = "7a7031966c424391bbab9900fcf3fa0a" # = ENV['OHANA_API_TOKEN'] if ENV['OHANA_API_TOKEN'].present?
        config.api_endpoint = "https://ohana-api.herokuapp.com/api/" # = ENV['OHANA_API_ENDPOINT']
    end
    
    @search = Ohanakapa.search("search", :keyword => params[:search_terms])
    erb(:show_search_results)
end
