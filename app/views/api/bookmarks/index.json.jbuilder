json.bookmarks do
  json.array! @bookmarks do |bookmark|
    json.partial! "api/bookmarks/bookmark", bookmark: bookmark
  end
end
