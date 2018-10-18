require "rest-client"
require "json"

class MailChimp
        
    class Api
        APP = RestClient
        DATA_CENTER = "us19"
        API_VERSION = "3.0"
        AUTH = {
            Authorization: "Bearer " + ENV["MC_AUTH_TOKEN"],
            Content_Type: "application/json"
        }
        def get(path)
            APP.get "https://#{DATA_CENTER}.api.mailchimp.com/#{API_VERSION}/#{path}", AUTH    
        end
        def post(path)
            APP.post "https://#{DATA_CENTER}.api.mailchimp.com/#{API_VERSION}/#{path}", AUTH
        end
    end

    class User

        def get_contact_info()
            api = Api.new
            data = api.get("")
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