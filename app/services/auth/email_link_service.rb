module Auth
  class EmailLinkService
    attr_reader :authenticatable

    def initialize(authenticatable:)
      @authenticatable = authenticatable
    end

    def find_or_create_auth_link
      URI.join(RibonCoreApi.config[:patrons][:app][:url], "/auth?authToken=#{auth_token}").to_s
    end

    private

    def auth_token
      find_token_on_redis || generate_new_auth_token
    end

    def find_token_on_redis
      RedisStore::HStore.get(key: "confirm_email_token_#{authenticatable.class.name}_#{authenticatable.id}")
    end

    def generate_new_auth_token
      RedisStore::HStore.set(key: "confirm_email_token_#{authenticatable.class.name}_#{authenticatable.id}",
                             value: SecureRandom.uuid, expires_in: 1.month)
    end
  end
end
