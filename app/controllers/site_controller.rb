class SiteController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def welcome
    page = HTTParty.get('http://games.espn.com/fhl/standings?leagueId=8266&seasonId=2017')
    parse_page = Nokogiri::HTML(page).css()

    parse_page = Nokogiri::HTML(page).css('.sortableTeamName').first.parent
    # @goals = parse_page.css('.sortableStat13')[0].children.text.to_i
    # @assts = parse_page.css('.sortableStat14')[0].children.text.to_i

    parse_page = Nokogiri::HTML(page).css('.sortableTeamName').first.parent

    # @data = []
    # parse_page.each do |ds|
    #   @data.push(ds.children)
    # end

    parse_page.map { |node| node.count }
    @data = parse_page

    # a title
    # Joker's Wild (Luke Kedziora)
  end

end
