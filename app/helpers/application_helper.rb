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

  def render_navbar
    if member_signed_in?
      render 'shared/react_navbar', navbar_items_data:
      [
        {
          type: 'header',
          href: admin_path,
          title: 'Admin'
        },
        {
          type: 'collapse',
          items: [
            {
              type: 'nav',
              items: [
                {
                  type: 'dropdown',
                  id: 'dropdown-admin',
                  title: 'Admin',
                  items: [
                    {
                      type: 'menu_item',
                      href: admin_contact_tickets_path,
                      title: 'Contact Tickets'
                    },
                    {
                      type: 'menu_item',
                      href: admin_opinions_path,
                      title: 'Opiniones'
                    },
                    {
                      type: 'menu_item',
                      href: admin_countries_path,
                      title: 'Países'
                    },
                    {
                      type: 'menu_item',
                      href: admin_genres_path,
                      title: 'Géneros'
                    },
                    {
                      type: 'menu_item',
                      href: admin_function_types_path,
                      title: 'Tipos de Función'
                    },
                    {
                      type: 'menu_item',
                      href: admin_settings_path,
                      title: 'Ajustes'
                    }
                  ]
                },
                {
                  type: 'dropdown',
                  id: 'dropdown-shows',
                  title: 'Cinemas',
                  items: [
                    {
                      type: 'menu_item',
                      href: admin_cinemas_path,
                      title: 'Todos'
                    },
                    {
                      type: 'divider'
                    },
                    {
                      type: 'menu_item',
                      href: admin_cinema_theaters_path('cinemark'),
                      title: 'Cinemark'
                    },
                    {
                      type: 'menu_item',
                      href: admin_cinema_theaters_path('cine-hoyts'),
                      title: 'Hoyts Santiago'
                    },
                    {
                      type: 'menu_item',
                      href: admin_cinema_theaters_path('cineplanet'),
                      title: 'Cineplanet'
                    },
                    {
                      type: 'menu_item',
                      href: admin_cinema_theaters_path('cinemundo'),
                      title: 'Hoyts Regiones'
                    },
                    {
                      type: 'menu_item',
                      href: admin_cinema_theaters_path('cine-pavilion'),
                      title: 'Pavilion'
                    },
                    {
                      type: 'menu_item',
                      href: admin_cinema_theaters_path('cinestar'),
                      title: 'Cinestar'
                    }
                  ]
                },
                {
                  type: 'nav_item',
                  href: admin_shows_path,
                  title: 'Shows'
                },
                {
                  type: 'dropdown',
                  id: 'dropdown-people',
                  title: 'Personas',
                  items: [
                    {
                      type: 'menu_item',
                      href: admin_people_path,
                      title: 'Todos'
                    },
                    {
                      type: 'divider'
                    },
                    {
                      type: 'menu_item',
                      href: new_admin_person_path,
                      title: 'Nuevo'
                    }
                  ]
                },
                {
                  type: 'nav_item',
                  href: admin_videos_path,
                  title: 'Videos'
                },
                {
                  type: 'nav_item',
                  href: admin_parsed_shows_path,
                  title: 'Parsed Shows'
                }
              ]
            },
            {
              type: 'nav_pull_right',
              items: [
                {
                  type: 'nav_item',
                  href: destroy_member_session_path,
                  "data-method" => 'delete',
                  title: 'Cerrar Sesión'
                }
              ]
            }
          ]
        }
      ]
    else
      render 'shared/react_navbar', navbar_items_data:
      [
        {
          type: 'collapse',
          items: [
            {
              type: 'nav_pull_right',
              items: [
                {
                  type: 'nav_item',
                  href: new_member_session_session_path,
                  title: 'Iniciar Sesión'
                }
              ]
            }
          ]
        }
      ]
    end
  end
end
