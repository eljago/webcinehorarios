module ApplicationHelper
  
  def is_active?(page_name)
    "active" if params[:ventana] == page_name
  end
  
  def shallow_args(parent, child)
	  child.try(:new_record?) ? [parent, child] : child
	end
	
	def namespace_shallow_args(namespace, parent, child)
	  child.try(:new_record?) ? [namespace, parent, child] : [namespace, child]
	end
	
	def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "btn btn-success add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
  
end
