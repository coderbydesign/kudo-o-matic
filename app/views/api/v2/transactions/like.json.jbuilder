json.key_format! :dasherize

json.data do
  json.title 'Successfully liked successfully'
  json.detail "The transaction record identified by id #{@transaction.id} was liked successfully."
end
