class PersonInterface < Hoodoo::Services::Interface
  interface :Person do
    endpoint :people, PersonImplementation
    public_actions :show, :list, :create, :update, :delete

    to_create do
      resource Resources::Person
    end

    update_same_as_create
  end
end