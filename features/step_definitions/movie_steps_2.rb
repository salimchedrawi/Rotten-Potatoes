# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  @total = 0
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    # cucumber can transfor table in the feature file to Table type
    # automatically, and then we should use the ActiveRecord to store
    # the movie objects to the database
    Movie.create!(movie)
    @total = @total + 1
  end
  #assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #  assert false, "Unimplmemented"
  # To Do
  content = page.body
  index_e1 = content.index(e1)
  index_e2 = content.index(e2)
  assert_equal true, index_e1 < index_e2
end

Then /^I should see all of the movies$/ do
  if page.respond_to? :should
    page.should have_css("table#movies tbody tr", :count => @total)
  else
    assert page.have_css?("table#movies tbody tr", :count => @total)
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list = rating_list.split(",")
  prefix = "ratings_"

  rating_list.each do |rating|
    if uncheck == "un"
      uncheck(prefix + rating)
    else
      check(prefix + rating)
    end
  end

end
