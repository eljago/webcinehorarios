class Admin::ParsedShowsController < ApplicationController

  def index
    @title = 'Parsed Shows'
    @app_name = 'ParsedShowsApp'
    @props = {}
    @prerender = false
    render file: 'react/render'
  end

end
