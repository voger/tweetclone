[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [
    # Kernel
    inspect: :*,

    # Phoenix
    plug: :*,
    action_fallback: :*,
    render: :*,
    redirect: :*,
    socket: :*,
    get: :*,
    post: :*,
    put: :*,
    resources: :*,
    pipe_through: :*,
    delete: :*,
    forward: :*,
    channel: :*,
    transport: :*,

    # Ecto Schema
    field: :*,
    belongs_to: :*,
    has_one: :*,
    has_many: :*,    
    embeds_one: :*,
    embeds_many: :*,
    many_to_many: :*,
    add: :*,

    # Ecto Query
    from: :*,
    
    # Ecto Migration
    create: :*,
    modify: :*,
    
    # Absinthe
    arg: :*,
    field: :*,
    resolve: :*,
    middleware: :*,
    trigger: :*,
    config: :*,
    parse: :*,
    serialize: :*,
    value: :*,
    resolve_type: :*,
    import_types: :*,
    import_fields: :*,
    interface: :*,
    union: :*,
  ]
]