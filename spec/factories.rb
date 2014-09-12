FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end
  
  factory :member do
    email
    password "foobar1525"
    password_confirmation "foobar1525"
    admin true
  end
  
  factory :cinema do
    name "Cinemark"
    information " "
  end
  
  factory :country do
    name "Chile"
  end
  
  factory :city do
    name "Santiago"
    country
  end
  
  factory :theater do
    address "Avenida Kennedy 9001, local 3092, Las Condes - Santiago / Mall Alto Las Condes."
    latitude "-33,3901201000"
    longitude "-70,5460327000"
    name "Alto Las Condes"
    web_url "http://www.cinemark.cl/theatres/alto-las-condes"
    active true
    cinema
    city
  end
  
  factory :show do
    name "Gravity"
    information "Astronautas tratan de regresar a la Tierra después de los accidentes de escombros en su nave espacial, dejándolos a la deriva solos en órbita."
    duration 90
    name_original "Gravity"
    rating "14+"
    debut Date.parse("2013-10-17")
    year 2013
    active true
    metacritic_url "http://www.metacritic.com/movie/gravity"
    metacritic_score 96
    imdb_code "tt1454468"
    imdb_score 81
    rotten_tomatoes_url "http://www.rottentomatoes.com/m/gravity_2013/"
    rotten_tomatoes_score 97
  end
  
end