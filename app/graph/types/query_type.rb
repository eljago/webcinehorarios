QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The query root of this schema. See available queries.'

  interfaces [GraphQL::Relay::Node.interface]
  global_id_field :id

  # Hack until relay has lookup for viewer fields
  field :viewer, ViewerType do
    description 'Root object to get viewer related collections'
    resolve -> (obj, args, ctx) { Viewer::STATIC }
  end
end