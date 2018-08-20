json.data do
  @graph.each {|month, data| json.set! month, data}
end
