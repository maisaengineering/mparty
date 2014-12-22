
namespace :db do
  task create_templates: :environment do
    Spree::Admin::Template.destroy_all


    ['Birthday','Wedding','Friendship day','Marriage day','Mother day'].to_a.each do |v|
      content1 = "<div style='height: 107px;width: 165px; background: wheat;'> Design for #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"
      content2 = "<div style='height: 107px;width: 165px; background: green;'>  Design for  #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"
      content3 = "<div style='height: 107px;width: 165px; background: red;'>  Design for  #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"
      content4 = "<div style='height: 107px;width: 165px; background: yellow;'>  Design for  #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"
      content5 = "<div style='height: 107px;width: 165px; background: blue;'>  Design for  #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"

      template = Spree::Admin::Template.new(name: v)
      template.designs.build(content: content1)
      template.designs.build(content: content2)
      template.designs.build(content: content3)
      template.designs.build(content: content4)
      template.designs.build(content: content5)
      template.save!
    end
  end
end
