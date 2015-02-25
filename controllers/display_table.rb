get "/results" do
  @display = display_join
  do_not_want_table
  erb :"show_table/results"
end