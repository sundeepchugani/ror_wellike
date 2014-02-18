module CategoryHelper

  def sort_by_adviser(data, *status)
  data.sort_by{| entry |
    [
      status.index(entry[:adviser]) || 999,
      entry[:age], entry[:name] #2nd sort criteria
    ]
  }
end
end
