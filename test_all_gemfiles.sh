# Execute rspec for each gemfile
for file in gemfiles/*.gemfile
do
  cmd="BUNDLE_GEMFILE=\"$file\" bundle exec rspec"
  echo $cmd
  eval $cmd
done
