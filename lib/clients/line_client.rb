# frozen_string_literal: true

class LineClient
  def initialize(channel_access_token, proxy = nil, api_url, )
    @channel_access_token = channel_access_token
    @proxy = proxy
    @api_url = api_url
    @client = build_http_client
  end

  def post!(path, data)
    response = @client.post do |request|
      request.url path
      request.headers = {
        content_type:'application/json',
        Authorization: Bearer #{@channel_access_token}'
      }
      request.body data
    end
    response
  end

  def reply(replyToken, text)
    messages = [
      {
        type: "text",
        text: "text"
      }
    ]

    body = {
      replyToken: replyToken,
      messages: messages
    }
    post('/v2/bot/message/reply', body.to_json)
  end

  private

  def build_http_client
    api_url = "https://api.line.me"

    Faraday.new(api_url) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end
end
