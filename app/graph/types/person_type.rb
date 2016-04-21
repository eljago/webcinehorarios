PersonType = GraphQL::ObjectType.define do
  name "Person"

  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id
  
  field :person_id, types.Int do
  	resolve -> (show_person_role, args, ctx) {
  		show_person_role.person.id
  	}
  end

  field :name, types.String do
    resolve -> (show_person_role, args, ctx) {
      show_person_role.person.name
    }
  end
  field :image_url, types.String do
    resolve -> (show_person_role, args, ctx) {
      show_person_role.person.image_url
    }
  end
  field :imdb_code, types.String do
    resolve -> (show_person_role, args, ctx) {
      show_person_role.person.imdb_code
    }
  end

  field :director, types.Boolean
  field :actor, types.Boolean
  field :character, types.String
end