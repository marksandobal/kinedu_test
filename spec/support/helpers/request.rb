module Helpers
  module Request
    def base_headers
      { 'Accept' => 'application/vnd.kinedu-api.v1+json' }
    end

    def authenticated_headers(token)
      base_headers.merge!(Authorization: JsonWebToken.encode(token))
    end
  end
end