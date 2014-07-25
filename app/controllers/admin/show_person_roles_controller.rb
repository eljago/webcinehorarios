#!/bin/env ruby
# encoding: utf-8
class Admin::ShowPersonRolesController < ApplicationController
  
  def sort
    if params[:showpersonroles].present?
      params[:showpersonroles].each_with_index do |id, index|
        ShowPersonRole.update_all({position: index+1}, {id: id})
      end
    end
    
    render nothing: true    
  end
  
end
