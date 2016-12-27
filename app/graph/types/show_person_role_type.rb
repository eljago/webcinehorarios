ShowPersonRoleType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'ShowPersonRole'

  field :person_id, types.Int
  field :show_id, types.Int
  field :actor, types.Boolean
  field :director, types.Boolean
  field :character, types.String
  field :position, types.Int
  field :person, PersonType
end
