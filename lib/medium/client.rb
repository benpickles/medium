require 'json'
require 'uri'

module Medium
  class Client
    API_BASE = 'https://api.medium.com'

    attr_reader :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    def create_post(params)
      request(:post, "/v1/users/#{user_id}/posts", params)
    end

    def me
      request(:get, '/v1/me')
    end

    def publication_contributors(publication_id)
      request(:get, "/v1/publications/#{publication_id}/contributors")
    end

    def publications
      request(:get, "/v1/users/#{user_id}/publications")
    end

    def request(method, path, data = nil)
      uri = URI.parse(API_BASE)
      uri.path = path

      case method
      when :post
        req = Net::HTTP::Post.new(uri)
        req.body = JSON.generate(data)
      else
        req = Net::HTTP::Get.new(uri)
      end

      req['Accept'] = 'application/json'
      req['Accept-Charset'] = 'utf-8'
      req['Authorization'] = "Bearer #{access_token}"
      req['Content-Type'] = 'application/json'

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http|
        http.request(req)
      }

      JSON.parse(res.body)
    end

    def user_id
      @user_id ||= me.fetch('data').fetch('id')
    end
  end
end
