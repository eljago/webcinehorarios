class Admin::HomeController < ApplicationController

  def index
    @navBarItemsData = [
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
                type: 'nav_item',
                href: admin_path,
                title: 'Link1'
              },
              {
                type: 'dropdown',
                id: 'dropdown-1',
                title: 'Dropdown',
                items: [
                  {
                    type: 'menu_item',
                    href: admin_path,
                    title: 'Dropdown Item 1'
                  },
                  {
                    type: 'divider'
                  },
                  {
                    type: 'menu_item',
                    href: admin_path,
                    title: 'Dropdown Item 2'
                  }
                ]
              }
            ]
          },
          {
            type: 'nav_pull_right',
            items: [
              {
                type: 'nav_item',
                href: admin_path,
                title: 'Link1'
              },
              {
                type: 'nav_item',
                href: admin_path,
                title: 'Link2'
              }
            ]
          }
        ]
      }
    ]
  end

end
