module SearchHelper
  def nothing_found(search)
    case search[0]
    when '#'
      "Tag \"#{search}\" is not found."
    when '@'
      "User with username \"#{search[1..-1]}\" is not found"
    else
      "Post contains \"#{search}\" is not found"
    end
  end
end
