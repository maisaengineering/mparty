
namespace :db do
  task create_templates: :environment do
    Spree::Admin::Template.destroy_all

    (0..25).to_a.each do |v|
      content1 = "<div style='height: 107px;width: 165px; background: wheat;'> Design for event #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"
      content2 = "<div style='height: 107px;width: 165px; background: green;'>  Design for event #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"
      content3 = "<div style='height: 107px;width: 165px; background: red;'>  Design for event #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"
      content4 = "<div style='height: 107px;width: 165px; background: yellow;'>  Design for event #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"
      content5 = "<div style='height: 107px;width: 165px; background: blue;'>  Design for event #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"
      content6 = "<div style='height: 107px;width: 165px; background: #325100;'>  Design for event #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"
      content7 = "<div style='height: 107px;width: 165px; background: #9FC562;'>  Design for event #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"
      content8 = "<div style='height: 107px;width: 165px; background: #838316;'>  Design for event #{v} <br/><span class='eventName'>{{ MPARTY.eventName }}</span><br/><span class='eventHost'>{{ MPARTY.eventHost }}</span><br/><span class='eventLocation'>{{ MPARTY.eventLocation }}</span><br/><span class='eventTime'>{{ MPARTY.eventTime }}</span></div>"

      template = Spree::Admin::Template.new(name: "Event #{v}")
      template.designs.build(content: content1)
      template.designs.build(content: content2)
      template.designs.build(content: content3)
      template.designs.build(content: content4)
      template.designs.build(content: content5)
      template.designs.build(content: content6)
      template.designs.build(content: content7)
      template.designs.build(content: content8)
      template.save!
    end
  end
end
