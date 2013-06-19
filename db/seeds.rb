# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Page.delete_all
Page.create!(permalink: 'contacto', title: 'Contacto', content: '');
Page.create!(permalink: 'inicio', title: 'Inicio', content: '');

User.delete_all
User.create!(name: 'admin', email: 'admin@example.cl', password: 'admin123', password_confirmation: 'admin123', admin: true);