require "net/http"

module Slack
  class Client
    RequestFailed = Class.new(StandardError)
    InviteFailed = Class.new(StandardError)

    def initialize(subdomain:, token:, d:)
      @subdomain = subdomain
      @token = token
      @d = d
    end

    def invite(email:, channels: [])
      res = Net::HTTP.start("#{@subdomain}.slack.com", 443, use_ssl: true) do |http|
        req = Net::HTTP::Post.new("/api/users.admin.invite?t=#{Time.now.to_i}")
        req["Cookie"] = "d=#{@d}"
        req.set_form_data \
          email:       email,
          channels:    channels.join(","),
          token:       @token,
          set_active:  "true",
          _attempts:   1

        http.request(req)
      end

      raise RequestFailed.new("HTTP status: #{res}") unless res.is_a?(Net::HTTPSuccess)

      body = JSON.parse(res.body)
      if !(body["ok"] || %w(already_in_team already_invited sent_recently).include?(body["error"]))
        raise InviteFailed.new(body.to_s)
      end

      true
    end
  end
end
