# frozen_string_literal: true

require 'twilio-ruby'

module Stealth
  module Services
    module TwilioVoice
      class MessageHandler < Stealth::Services::BaseMessageHandler
        attr_reader :service_message, :params, :headers

        def initialize(params:, headers:)
          @service = "twilio_voice"
          @params = params
          @headers = headers
        end

        def coordinate
          dispatcher = Stealth::Dispatcher.new(
            service: @service,
            params: params,
            headers: headers
          )

          dispatcher.process

          puts "SENDING: #{Thread.current[:voice_reply]}"

          send_voice_reply
        end

        def process
          @service_message = ServiceMessage.new(service: 'twilio_voice')
          service_message.sender_id = params['From']
          service_message.target_id = params['To']
          if params["Digits"].present?
            service_message.message = params["Digits"]
          elsif params["SpeechResult"].present?
            service_message.message = params["SpeechResult"]
            service_message.confidence = parse_float(params["Confidence"])
          end

          puts "Webhook from Twilio: #{params.inspect}"

          service_message
        end

      private

        def send_voice_reply
          response_headers = { 'Content-Type' => 'text/xml' }
          [200, response_headers, Thread.current[:voice_reply].to_s]
        end

        def parse_float(float)
          Float(float)
        rescue TypeError
          return nil
        rescue ArgumentError
          return nil
        end
      end
    end
  end
end
