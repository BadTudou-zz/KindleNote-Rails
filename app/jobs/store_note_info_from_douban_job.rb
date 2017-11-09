require 'net/http'
require 'uri'
require 'json'

class StoreNoteInfoFromDoubanJob < ApplicationJob
  queue_as :default

  def perform(*args)
    note = Note.find(args.first)
    begin
        uri = URI.parse("https://api.douban.com/v2/book/search")
        args = {q: note.title, count: 1}
        uri.query = URI.encode_www_form(args)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        book = JSON.parse(response.body.force_encoding("UTF-8"))
        note.cover_url = book["books"][0]["images"]["large"] || ''
        note.rating = book["books"][0]["rating"]["average"] || 0
        note.summary = book["books"][0]["summary"] || ''
        note.save
    rescue Exception => e
        puts e
    end
    # Do something later
  end
end
