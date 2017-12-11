json.key_format! :dasherize

json.data do
  json.title 'Successfully unliked successfully'
  json.detail "The transaction record identified by id #{@transaction.id} was unliked successfully."
end
