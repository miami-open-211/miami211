[![Code Climate](https://codeclimate.com/github/Code-for-Miami/miami211/badges/gpa.svg)](https://codeclimate.com/github/Code-for-Miami/miami211) [![Test Coverage](https://codeclimate.com/github/Code-for-Miami/miami211/badges/coverage.svg)](https://codeclimate.com/github/Code-for-Miami/miami211/coverage)

# Miami 211 Rebuild

A simple front-end for a [Ohana API](https://github.com/codeforamerica/ohana-api), originally produced for the Miami 211 project. 

### Who is this made by?

This project was originally developed by Ernie Hsiung and [David James Knight](https://github.com/davidjamesknight). See the full [contributors list](https://github.com/Code-for-Miami/miami211/graphs/contributors).

### Who is using this platform?

- [Prototype](https://mia211.herokuapp.com/) for Jewish Health Services

### Screenshots

![image](https://cloud.githubusercontent.com/assets/33945/23799160/88a62084-0575-11e7-8b5b-379eed21f0e1.png)

![image](https://cloud.githubusercontent.com/assets/33945/23799187/abe2b68e-0575-11e7-8569-722b1f822558.png)


## Under the hood
While we used Ruby (tested up to v2.3.0) and Sinatra to stand this up, so to speak, much of the leg work is HTML, CSS and Javascript (jQuery, leaflet.js, Mapbox georeference APIs). Ohana API has a ruby gem called Ohanakapa that we used for API access; there is no local data storage being used in this prototype.

## Quick Start
### Initial setup

    cd [project_directory]
    bundle install 
    
### Starting the app

    cd [project_directory]
    ruby server.rb
    
### In the browser

    localhost:4567
    
## API

 * [Ohana API Endpoint](https://ohana-api.herokuapp.com/api/)
 * [Ohana API locations, in json format](https://ohana-api.herokuapp.com/api/locations)
