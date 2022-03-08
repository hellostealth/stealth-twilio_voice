# frozen_string_literal: true

require 'stealth/services/twilio_voice/client'

module Stealth
  module Services
    module TwilioVoice

      class Setup

        class << self
          def trigger
            Stealth::Logger.l(
              topic: "twilio",
              message: "There is no setup needed!"
            )
          end
        end

      end

    end
  end
end
