require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    { "id" => "evt_16oCHmA85nYsHkIKmb9FGGbI",
      "created" => 1443011026,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_16oCHmA85nYsHkIKTK0PV3tl",
          "object" => "charge",
          "created" => 1443011026,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_16oCHkA85nYsHkIK9a41Skk5",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 9,
            "exp_year" => 2017,
            "fingerprint" => "o7wSBIKyXzvPqrYc",
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
            "customer" => "cus_72GplbEAQZw8fa"
          },
          "captured" => true,
          "balance_transaction" => "txn_16oCHmA85nYsHkIKCri1QyT4",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_72GplbEAQZw8fa",
          "invoice" => "in_16oCHmA85nYsHkIK34Pvde5X",
          "description" => nil,
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
            "url" => "/v1/charges/ch_16oCHmA85nYsHkIKTK0PV3tl/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "req_72GpUy503BsKdO",
      "api_version" => "2015-09-08"
    }
  end

  it "creates a payment with the webook from stripe for charge succeeded", vcr: true do  
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", vcr: true do
    alice = Fabricate(:user, customer_token: "cus_72GplbEAQZw8fa")
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", vcr: true do
    alice = Fabricate(:user, customer_token: "cus_72GplbEAQZw8fa")
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_72GplbEAQZw8fa")
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq('ch_16oCHmA85nYsHkIKTK0PV3tl')
  end
end