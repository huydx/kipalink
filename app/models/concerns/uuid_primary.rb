module UuidPrimary
  extend ActiveSupport::Concern

  included do
    before_create :generate_id_as_uuid

    private

    def generate_id_as_uuid
      class_name = self.class.name

      code = <<-GENERATOR
        self.id = loop do
          random_token = SecureRandom.urlsafe_base64(nil, false)
          break random_token unless #{class_name}.exists?(id: random_token)
        end
      GENERATOR

      eval(code)
    end
  end
end
