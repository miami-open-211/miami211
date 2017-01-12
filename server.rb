system("clear")

require "ohanakapa"
require "sinatra"
require "sinatra/reloader" if development?

# HOME ==========================================

get "/" do
    @hide_search = true # Hide search field in navbar
    erb(:home)
end


# SEARCH RESULTS ================================
# /org_search?search_terms

get "/org_search" do 
    
    # Ohanakapa gem handles API call
    Ohanakapa.configure do |config|
        # DEVELOPMENT
        config.api_token = "7a7031966c424391bbab9900fcf3fa0a" 
        config.api_endpoint = "https://ohana-api.herokuapp.com/api/" 
        
        # PRODUCTION
        # config.api_token = ENV['OHANA_API_TOKEN'] if ENV['OHANA_API_TOKEN'].present?
        # config.api_endpoint = ENV['OHANA_API_ENDPOINT']
    end
    
    @search = Ohanakapa.search("search", :keyword => params[:search_terms])
    
    @search.sort_by! do |org| # Alphabetize results
        org.organization.name
    end
    @refine_by = {
        "zip" => [],
        "city" => []
        }
    @scripts = ["map.js", "search_results.js"] # All ./public/js files running on this page
    
    def remove_escape_chars(search)
        search.each do |org|
            org.organization.description.gsub!("\\n*", "<br/>")
            org.organization.description.gsub!("\\n", "<p/>")
            org.organization.description.gsub!("\\r", "")
            org.organization.description.gsub!("###MON###", "")
            org.organization.description.gsub!("###COL###","")
        end
    end
    remove_escape_chars(@search)
    
    # Extract cities & ZIP codes from results for 'Refine by' column
    def get_refine_by(search)
        search.each do |org|
            if @refine_by["zip"].include?(org.address.postal_code) == false
                @refine_by["zip"] << org.address.postal_code[0..4]
            end
            if @refine_by["city"].include?(org.address.city) == false
                @refine_by["city"] << org.address.city
            end
        end
        @refine_by["zip"].sort!
        @refine_by["city"].sort!    
    end   
    get_refine_by(@search)
    
    # Render "Search results" page
    erb(:search_results)
    
end
