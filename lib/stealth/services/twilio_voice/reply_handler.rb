# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module TwilioVoice
      class ReplyHandler < Stealth::Services::BaseReplyHandler

        attr_reader :recipient_id, :reply, :voice_reply

        def initialize(recipient_id: nil, reply: nil)
          @recipient_id = recipient_id
          @reply = reply
          @voice_reply = Thread.current[:voice_reply] || ::Twilio::TwiML::VoiceResponse.new
        end

        def speech
          # Say options: https://www.twilio.com/docs/voice/twiml/say
          voice_reply.say(
            message: reply["speech"],
            voice: Stealth.config.twilio_voice.voice
          )
          voice_reply
        end

        def delay
          # Pause options: https://www.twilio.com/docs/voice/twiml/pause
          voice_reply.pause(length: reply["duration"])
          voice_reply
        end

        def play
          # Play options: https://www.twilio.com/docs/voice/twiml/play
          loop_val = reply["loop"] || 1
          voice_reply.play(loop: loop_val, url: reply["url"])
          voice_reply
        end

        def gather
          # Gather options: https://www.twilio.com/docs/voice/twiml/gather
          finish_key        = reply["finish_key"]       || "#"
          timeout           = reply["timeout"]          || 5
          speech_timeout    = reply["speech_timeout"]   || "auto"
          num_digits        = reply["num_digits"]       || 5
          profanity_filter  = reply["profanity_filter"] || true
          language          = reply["language"]         || "en-US"
          hints             = reply["hints"]&.join(",") || ""
          # dtmf, speech, dtmf speech
          input             = reply["input"]            || "dtmf"
          # Must utilize speech_model "phone_call"
          enhanced          = reply["enhanced"]         || false
          # default, number_and_commands, phone_call
          speech_model      = reply["speech_model"]     || "default"

          voice_reply.gather(
            input: input,
            finish_on_key: finish_key,
            timeout: timeout,
            speech_timeout: speech_timeout,
            num_digits: num_digits,
            profanity_filter: profanity_filter,
            language: language,
            hints: hints,
            enhanced: enhanced,
            speech_model: speech_model
          )

          voice_reply
        end
      end
    end
  end
end
