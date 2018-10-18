require "rest-client"
require "json"

class MailChimp
        
    class Api
        APP = RestClient
        AUTH = {
            Authorization: "Bearer " + ENV["MC_AUTH_TOKEN"],
            Content_Type: "application/json"
        }
        def get(data_center, api_version, path)
            APP.get "https://#{data_center}.api.mailchimp.com/#{api_version}/#{path}", AUTH    
        end
        def post(data_center,api_version,path)
            APP.post "https://#{data_center}.api.mailchimp.com/#{api_version}/#{path}", AUTH
        end
    end

    class User

        def get_contact_info()
            api = Api.new
            data = api.get("us19","3.0","")
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
        def create()
        end
        def get_id_by_name()
        end
        def add_field()
        end

    end
end

user = MailChimp::User.new
puts user.get_contact_info()