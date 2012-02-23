module Heroku
  class StaticAssetsMiddleware
    def cache_static_asset(reply)
      return reply unless can_cache?(reply)
      status, headers, response = reply
      headers["Expires"] = CGI.rfc1123_date(11.months.from_now)
      build_new_reply(status, headers, response)
    end
  end
end
