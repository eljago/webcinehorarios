ShowType = GraphQL::ObjectType.define do
  name "Show"
  description "A Show"

  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id
  field :name, types.String, "Name of the Show"
  field :information, types.String, "Synopsis of the Show"
end