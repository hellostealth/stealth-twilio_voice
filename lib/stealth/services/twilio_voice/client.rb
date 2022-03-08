# frozen_string_literal: true

require 'twilio-ruby'

require 'stealth/services/twilio_voice/message_handler'
require 'stealth/services/twilio_voice/reply_handler'
require 'stealth/services/twilio_voice/setup'

module Stealth
  module Services
    module TwilioVoice
      class Client < Stealth::Services::BaseClient

        attr_reader :reply

        def initialize(reply:)
          @reply = reply
        end

        def transmit
          Thread.current[:voice_reply] = reply[:msg]

          Stealth::Logger.l(
            topic: :twilio_voice,
            message: "Audio reply sent."
          )
        end

      end
    end
  end
end
