system("clear")

require "ohanakapa"
require "sinatra"
require "sinatra/reloader" if development?
require 'rack/ssl-enforcer' if production?

use Rack::SslEnforcer if production?

# HOME ==========================================

get "/" do
    @hide_search = true # Hide search field in navbar
     @scripts = ["search_suggest.js"] 
    erb(:home)
end


# SEARCH RESULTS ================================

get "/org_search" do # GET: /org_search?search_terms
    
    # Set up Ohanakapa gem to handle API call
    Ohanakapa.configure do |config|
        # DEVELOPMENT
#        config.api_token = "" 
#        config.api_endpoint = "https://ohana-api.herokuapp.com/api/" 
        
        # PRODUCTION
         config.api_token = ENV['OHANA_API_TOKEN']
         config.api_endpoint = ENV['OHANA_API_ENDPOINT']
    end
    
    # Run a keyword search and put the results in an array named @search, which we will later send to the view

    @search = Ohanakapa.search("search", :keyword => params[:search_terms], :per_page => 100, :location => "215 NE 82nd Ter, Miami, Florida 33138, United States", :radius => 100)
    
    # Iterate through results, fetch each result by :id, and add :categories (this is a temporary measure until API is updated)
    def getServices(org)
       find_by_id = Ohanakapa.location(org.id)
        if find_by_id.services[0] != nil
            org[:categories] = find_by_id.services[0].categories.map do |x|
                x.name
            end
            org[:categories].sort!
        else
            org[:categories] = []
        end
#        org[:categories] = ["One", "Two", "Three"]   # For development only     
    end
    
    @search.each do |org|
        getServices(org)
    end
    
    @search.sort_by! do |org| # Alphabetize results
        org.organization.name
    end
    @refine_by = {
        "city" => [],
        "zip" => [],
        "category" => []
        }
    
    # List all JS files to load on this page (stored in ./public/js/)
    # map_geo.js is being compiled through browserify and stored in bundle.js
    # which is being stored in the head.
    @scripts = ["map.js", "map_geo.js", "search_results.js", "search_suggest.js"] 
    
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
            if @refine_by["zip"].include?(org.address.postal_code) == false
                @refine_by["zip"] << org.address.postal_code[0..4]
            end
            if @refine_by["city"].include?(org.address.city) == false
                @refine_by["city"] << org.address.city
            end
            org.categories.each do |category|
                if @refine_by["category"].include?(category) == false
                    @refine_by["category"] << category
                end
            end
        end
        @refine_by["zip"].sort!
        @refine_by["city"].sort! 
        @refine_by["category"].sort! 
    end  
    
    remove_escape_chars(@search)
    get_refine_by(@search)
    
    erb(:search_results) # Render ./views/search_results
    
end
