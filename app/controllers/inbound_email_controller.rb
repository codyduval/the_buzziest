class InboundEmailController < ApplicationController
  skip_before_filter :verify_authenticity_token


  def create
    @buzz_post = BuzzPost.create_from_postmark(Postmark::Mitt.new(request.body.read))
    @buzz_post.buzz_source_id = BuzzPost.assign_buzz_source_id("email",params[:city])
    @buzz_post.post_weight = @buzz_post.buzz_source.buzz_weight
    @buzz_post.scanned_flag = false
    @buzz_post.post_uri = "not applicable - inbound emailr"
    @buzz_post.post_date_time = DateTime.now
    @buzz_post.save
    if @buzz_post.present?
      render :text => "Created a post!", :status => :created
    else
      render :text => "Didn't Create a post!", :status => :created
    end
  end

end
