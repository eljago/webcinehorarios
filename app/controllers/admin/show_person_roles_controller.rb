#!/bin/env ruby
# encoding: utf-8
class Admin::ShowPersonRolesController < ApplicationController
  
  def sort
    if params[:show_person_roles].present?
      params[:show_person_roles].each_with_index do |id, index|
        ShowPersonRole.where(id: id).update_all(position: index+1)
      end
    end
    
    render nothing: true    
  end
end
