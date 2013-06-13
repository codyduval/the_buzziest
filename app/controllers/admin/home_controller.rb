module Admin
  class HomeController < AdminController
    def index
      @buzz_mentions = BuzzMention.all
      gon.rabl "app/views/admin/buzz_mentions/index.json.rabl", as: "buzz_mentions"
    end
  end
end
