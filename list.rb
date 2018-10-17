require 'rest-client'
require 'json'

LANGUAGE = "english"
DATA_CENTER = "us19"


def get_mailchimp_contact_info()
    data = RestClient.get "https://#{DATA_CENTER}.api.mailchimp.com/3.0/", 
    {
        Authorization: "Bearer " + ENV["MC_AUTH_TOKEN"],
        Content_Type: "application/json"
    }
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

def find_mailchimp_list_id_by_name(search_string)
    id = ""
    data = RestClient.get "https://#{DATA_CENTER}.api.mailchimp.com/3.0/lists", 
    {
        Authorization: "Bearer " + ENV["MC_AUTH_TOKEN"],
        Content_Type: "application/json"
    }
    data = JSON.parse(data)
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

def create_mailchimp_list(list_name)
    user_contact_info = get_mailchimp_contact_info()
    RestClient.post "https://#{DATA_CENTER}.api.mailchimp.com/3.0/lists", 
    {
        "name": list_name,
        "contact": {
            company: user_contact_info[:company],
            address1: user_contact_info[:address1],
            city: user_contact_info[:city],
            state: user_contact_info[:state],
            zip: user_contact_info[:zip],
            country: user_contact_info[:country]
        },
        "permission_reminder": "you signed up for this bc you love me",
        "campaign_defaults": {
            from_name: user_contact_info[:from_name],
            from_email: user_contact_info[:from_email],
            subject: "TBD yall",
            language: LANGUAGE
        },
        email_type_option: false
    }.to_json,
    {
        Authorization: "Bearer " + ENV["MC_AUTH_TOKEN"],
        Content_Type: "application/json"
    }
end

def add_field_to_list(list_id, field_name, field_type)
end