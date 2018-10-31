require "rest-client"
require "json"

class MailChimp

    # def initialize(data_center, api_version, language)
    #     DATA_CENTER = data_center
    #     API_VERSION = api_version
    #     LANGUAGE = language
    # end
        
    class Api
        APP = RestClient
        DATA_CENTER = "us19"
        API_VERSION = "3.0"
        AUTH = {
            Authorization: "Bearer " + ENV["MC_AUTH_TOKEN"],
            Content_Type: "application/json"
        }
        def self.get(path)
            APP.get "https://#{DATA_CENTER}.api.mailchimp.com/#{API_VERSION}/#{path}", AUTH    
        end
        def self.post(path, payload)
            APP.post "https://#{DATA_CENTER}.api.mailchimp.com/#{API_VERSION}/#{path}", payload, AUTH
        end
    end

    class User

        def self.get_contact_info()
            data = Api.get("")
            data = JSON.parse(data)
            contact = data["contact"]
            return {
                company: contact["company"],
                address1: contact["addr1"],
                city: contact["city"],
                state: contact["state"],
                zip: contact["zip"],
                country: contact["country"],
                from_name: "#{data["first_name"]} #{data["last_name"]}",
                from_email: data["email"]
            }
        end
    end

    class List

        def self.create(list_name, permission_reminder, email_subject)
            user_contact_info = User.get_contact_info()
            Api.post("lists", 
            {
                name: list_name,
                contact: {
                    company: user_contact_info[:company],
                    address1: user_contact_info[:address1],
                    city: user_contact_info[:city],
                    state: user_contact_info[:state],
                    zip: user_contact_info[:zip],
                    country: user_contact_info[:country]
                },
                "permission_reminder": permission_reminder,
                campaign_defaults: {
                    from_name: user_contact_info[:from_name],
                    from_email: user_contact_info[:from_email],
                    subject: email_subject,
                    language: "english"
                },
                email_type_option: false
            }.to_json)
        end

        def self.find_by_name(search_string)
            data = JSON.parse(Api.get("lists"))
            lists = data["lists"]
            found_list = lists.select{|i| i["name"].include? search_string}
            if found_list.length > 1
                return "Multiple lists found. Narrow search"
            elsif found_list.length == 1
                return found_list[0]["id"]
            elsif found_list.length == 0
                return "List not found"
            end
        end

        def self.add_field(list_id, field_name, field_type)
            Api.post("lists/#{list_id}/merge-fields",
            {
                name: field_name,
                type: field_type
        }.to_json)
        end

    end
end