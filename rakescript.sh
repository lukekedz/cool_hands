# SOURCE http://www.maclife.com/article/columns/terminal_101_automate_terminal_bash_scripts

# $> bundler exec ./rakescript.sh OR bash rakescript.sh

rake db:drop
rake db:create
rake db:migrate
rake db:seed