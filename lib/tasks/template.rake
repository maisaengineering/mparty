
namespace :db do
    task create_templates: :environment do
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_admin_templates;")
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_admin_designs;")
        ['New year','Birthday','Wedding','Friendship day','Marriage day','Mother day'].to_a.each_with_index do |v|
            template = Spree::Admin::Template.new(name: v)
            ['#eee354','green','red','blue'].each_with_index do |c,i|
                template.designs.build(content: template_content(c,i))
            end
            template.save!
        end
    end


    def template_content(color= 'wheat',index=0)
        <<-EOD
     <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

    <style type="text/css">

        body {
            padding: 0px;
            margin: 0px;
        }

        .eventDesignWrapper-#{index} {
            padding: 0px;
            margin-left: auto;
            margin-right: auto;
            margin-top: 0px;
            margin-bottom: 0px;
            position: relative;
        }

        .eventDesignWrapper-#{index} .eventDesignContainer {
            background-image: url(http://sadacreator.esy.es/template_2.png);
            background-position: center center;
            background-repeat: no-repeat;
            font-family: "ProximaNova-Regular", Arial, Helvetica, sans-serif;
            font-size: 25px;
            font-weight: normal;
            width: 900px;
            height: 643px;
            position: relative;
        }

        .eventDesignWrapper-#{index} .eventDesignBody {
            height: 578px;
            width: 412px;
            position: relative;
            left: 448px;
            margin-left: 20px;
            margin-right: 20px;
            text-align: center;
        }

        .eventDesignWrapper-#{index} .eventDesignHostname {
            font-size: 55px;
            color: #777;
            padding-top: 58px;
            line-height: 58px;
            text-transform: lowercase;
            /*font-family: "ConeriaScriptMedium", "Palatino Linotype", "Book Antiqua", Palatino, serif;*/
        }

        .eventDesignWrapper-#{index} .eventDesignEventName {
            font-size: 64px;
            line-height: 58px;
            color: #777;
            text-transform: lowercase;
            font-family: "ConeriaScriptMedium", "Palatino Linotype", "Book Antiqua", Palatino, serif;
        }

        .eventDesignWrapper-#{index} .eventDesignEventDate {
            font-size: 25px;
            line-height: 25px;
            color: #fff;
            background-color: #bfbfbf;
            height: 28px;
            padding-top: 4px;
            width: 340px;
            margin-left: auto;
            margin-right: auto;
            margin-top: 5px;
        }

        .eventDesignWrapper-#{index} .eventDesignEventText {
            font-size: 25px;
            color: #777;
            line-height: 1.2em;
        }

        .eventDesignWrapper-#{index} .eventDesignEventText table {
            width: 100%;
            height: 145px;
        }

        .eventDesignWrapper-#{index} .eventDesignEventText td {
            vertical-align: middle;
            text-align: center;
        }

        .eventDesignWrapper-#{index} .eventDesignPhoto {
            position: absolute;
            left: 0px;
            top: 0px;
            width: 451px;
            height: 578px;
            background-position: center center;
            background-repeat: no-repeat;
            background-size: auto 578px;
            text-align: center;
        }

        .eventDesignWrapper-#{index} .eventDesignPhotoTemp {
            opacity: .3;
            filter: alpha(opacity=30);
        }

        .eventDesignWrapper-#{index} .eventDesignPhotoTemp:before {
            content: "\A \A \A add your own photo";
            white-space: pre-wrap;
            width: 100%;
            text-align: center;
            color: #000;
            font-size: 35px;
        }

        .eventDesignWrapper-#{index} .eventDesignFooter {
            height: 65px;
            background-color: #{color};
            background-position: 505px center;
            background-repeat: no-repeat;
            padding-left: 40px;
            padding-right: 495px;
            text-align: center;
        }

        .eventDesignWrapper-#{index} .eventDesignSponsor {
            display: inline-block;
            margin-left: auto;
            margin-right: auto;
            margin-top: -25px;
            text-align: center;
            height: 90px;
            background-color: #bfbfbf;
            padding-left: 15px;
            padding-right: 15px;
            border-left: solid 4px #fff;
            border-right: solid 4px #fff;
            position: relative;
            z-index: 1;
        }

        .eventDesignWrapper-#{index} .eventDesignSponsor table {
            width: 100%;
            height: 100%;
            margin: 0px;
            padding: 0px;
        }

        .eventDesignWrapper-#{index} .eventDesignSponsor td {
            width: 100%;
            height: 100%;
            vertical-align: middle;
        }

        .eventDesignWrapper-#{index} .eventDesignSponsor img {
            vertical-align: middle;
        }

    </style>
</head>
<body>

<div class="eventDesignWrapper-#{index}">
    <div class="eventDesignContainer">
        <div class="eventDesignBody">
            <div class="eventDesignHostname">
                {{#if MPARTY.eventHostName}}
                  {{MPARTY.eventHostName}}
                {{ else }}
                  Host Name
                {{/if}}
            </div>
            <div class="eventDesignEventName">
                {{#if MPARTY.eventName}}
                  {{ MPARTY.eventName }}
                {{ else }}
                  Event Name
                {{/if}}
            </div>
            <div class="eventDesignEventDate">
                {{#if MPARTY.eventTime}}
                  {{ MPARTY.eventTime }}
                {{ else }}
                  Event Time
                {{/if}}
            </div>
            <div class="eventDesignEventText">
                <table>
                    <tr>
                        <td>
                            {{#if MPARTY.eventDescription}}
                              {{ MPARTY.eventDescription }}
                            {{ else }}
                              Description
                            {{/if}}
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="eventDesignPhoto" style="">
        </div>
        <div class="eventDesignFooter">
            <div class="eventDesignSponsor"><table><tr><td>
                {{ MPARTY.templateName }}
            </td></tr></table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
        EOD
    end


end
