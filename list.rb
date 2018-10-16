require 'rest-client'
require 'json'


def get_mailchimp_contact_info()
    data = RestClient.get "https://us19.api.mailchimp.com/3.0/", 
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

def get_mailchimp_list()
end

def create_mailchimp_list(name)
    user_contact_info = get_mailchimp_contact_info()
    RestClient.post "https://us19.api.mailchimp.com/3.0/lists", 
    {
        "name": name,
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
            language: "english"
        },
        email_type_option: false
    }.to_json,
    {
        Authorization: "Bearer " + ENV["MC_AUTH_TOKEN"],
        Content_Type: "application/json"
    }
end

def add_field_to_list(name, type)
end

create_mailchimp_list("another test")