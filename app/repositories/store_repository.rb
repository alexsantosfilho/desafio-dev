class StoreRepository
  def self.find_or_create_by_name_and_owner(name, owner)
    Store.find_or_create_by(name: name, owner: owner)
  end
end
