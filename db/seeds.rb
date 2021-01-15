# Create default user

default_user = User.find_or_initialize_by(username: Rails.configuration.x.default_user.username)
default_user.password = Rails.configuration.x.default_user.password
default_user.uid ||= SecureRandom.uuid
default_user.save!
