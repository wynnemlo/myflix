require 'spec_helper'

describe "Deactivate user on failed charge" do
  let(:event_data) do
  {
    "id" => "evt_16oEBXA85nYsHkIKmifaq5Mt",
    "created" => 1443018327,
    "livemode" => false,
    "type" => "charge.failed",
    "data" => {
      "object" => {
        "id" => "ch_16oEBXA85nYsHkIKi4hPwFlS",
        "object" => "charge",
        "created" => 1443018327,
        "livemode" => false,
        "paid" => false,
        "status" => "failed",
        "amount" => 999,
        "currency" => "usd",
        "refunded" => false,
        "source" => {
          "id" => "card_16oEAmA85nYsHkIKYEgEWvsU",
          "object" => "card",
          "last4" => "0341",
          "brand" => "Visa",
          "funding" => "credit",
          "exp_month" => 9,
          "exp_year" => 2018,
          "fingerprint" => "1j0iJnxBrSpa65IF",
          "country" => "US",
          "name" => nil,
          "address_line1" => nil,
          "address_line2" => nil,
          "address_city" => nil,
          "address_state" => nil,
          "address_zip" => nil,
          "address_country" => nil,
          "cvc_check" => "pass",
          "address_line1_check" => nil,
          "address_zip_check" => nil,
          "tokenization_method" => nil,
          "dynamic_last4" => nil,
          "metadata" => {},
          "customer" => "cus_72Ic1prqSzQVlj"
        },
        "captured" => false,
        "balance_transaction" => nil,
        "failure_message" => "Your card was declined.",
        "failure_code" => "card_declined",
        "amount_refunded" => 0,
        "customer" => "cus_72Ic1prqSzQVlj",
        "invoice" => nil,
        "description" => "payment to fail",
        "dispute" => nil,
        "metadata" => {},
        "statement_descriptor" => nil,
        "fraud_details" => {},
        "receipt_email" => nil,
        "receipt_number" => nil,
        "shipping" => nil,
        "destination" => nil,
        "application_fee" => nil,
        "refunds" => {
          "object" => "list",
          "total_count" => 0,
          "has_more" => false,
          "url" => "/v1/charges/ch_16oEBXA85nYsHkIKi4hPwFlS/refunds",
          "data" => []
        }
      }
    },
    "object" => "event",
    "pending_webhooks" => 1,
    "request" => "req_72InLnwSEVxPLE",
    "api_version" => "2015-09-08"
  }
  end
  
  it "deactivates a user with the web hook data from stripe for charge failed", :vcr do
    alice = Fabricate(:user, customer_token: "cus_72Ic1prqSzQVlj")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end