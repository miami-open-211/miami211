system("clear")

require "ohanakapa"
require "sinatra"
require "sinatra/reloader" if development?
require 'rack/ssl-enforcer' if production?

use Rack::SslEnforcer if production?

# HOME ==========================================

get "/" do
    @hide_search = true # Hide search field in navbar
     @scripts = ["map_geo.js"] 
    
    # A/B testing for auto-suggest
    @version = rand(0..1)
    if @version == 0
        @scripts << "search_suggest.js"
    end
    
    erb(:home)
end


# SEARCH RESULTS ================================

get "/org_search" do # GET: /org_search?search_terms
    
    # Set up Ohanakapa gem to handle API call
    Ohanakapa.configure do |config|
        if settings.development?
            config.api_token = "" 
            config.api_endpoint = "https://ohana-api.herokuapp.com/api/" 
        else
            config.api_token = ENV['OHANA_API_TOKEN']
            config.api_endpoint = ENV['OHANA_API_ENDPOINT']
        end
    end
    
#    Set a default downtown Miami address at Flagler & Miami Ave
    if params[:address] != ""
        @address = params[:address]
    else
        @address = "1 NE 1st Ave, Miami, Florida 33132, United States"
    end

    # Run a keyword search and put the results in an array named @search, which we will later send to the view
    @search = Ohanakapa.search("search", :keyword => params[:search_terms], :per_page => 100, :location => @address, :radius => 100)
    
    # Iterate through results, fetch each result by :id, and add :categories (this is a temporary measure until API is updated)
    def getServices(org)
        if settings.development?
            arr = ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India"]
            org[:categories] = [arr[rand(0..2)], arr[rand(3..5)], arr[rand(6..8)]].sort
        else # Fetch categories for production only (fewer API calls)
            find_by_id = Ohanakapa.location(org.id)
            if find_by_id.services[0] != nil
                org[:categories] = find_by_id.services[0].categories.map do |x|
                    x.name
                end
                org[:categories].sort!
            else
                org[:categories] = []
            end
        end
    end
    
    @search.each do |org|
        getServices(org)
    end
    
    @search.sort_by! do |org| # Alphabetize results
        org.organization.name
    end
    
    @refine_by = []
    
    # List all JS files to load on this page (stored in ./public/js/)
    # map_geo.js is being compiled through browserify and stored in bundle.js
    # which is being stored in the head.
    @scripts = ["map.js", "map_geo.js", "refine_by_category.js", "refine_by_radius.js"] 
    
    def remove_escape_chars(search)
        search.each do |org|
            org.organization.description.gsub!("\\n*", "<br/>")
            org.organization.description.gsub!("\\n", "<p/>")
            org.organization.description.gsub!("\\r", "")
            org.organization.description.gsub!("###MON###", "")
            org.organization.description.gsub!("###COL###", "")
            org.organization.description.gsub!("##", "")
        end
    end
    
    # Get list of unique cities, ZIP codes & categories from @search for use in 'Refine by' column
    def get_refine_by(search)
        search.each do |org|
            org.categories.each do |cat|
#                if @refine_by.include?(cat) == false
                    @refine_by << cat
#                end
            end
        end
        @refine_by = @refine_by.each_with_object(Hash.new(0)) do |name, hash|
            hash[name] += 1
        end
        @refine_by = Hash[ @refine_by.sort_by { |key, val| key }]
    end  
    
    remove_escape_chars(@search)
    get_refine_by(@search)
    
    erb(:search_results) # Render ./views/search_results
    
end
