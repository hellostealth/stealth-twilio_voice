# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module TwilioVoice
      class ReplyHandler < Stealth::Services::BaseReplyHandler

        attr_reader :recipient_id, :replies

        def initialize(recipient_id: nil, replies: nil)
          @recipient_id = recipient_id
          @replies = replies
        end

        def build_reply
          voice_reply = ::Twilio::TwiML::VoiceResponse.new do |r|
            replies.each do |reply|
              case reply["reply_type"]
              when "speech"
                # Say options: https://www.twilio.com/docs/voice/twiml/say
                r.say(
                  message: reply["speech"],
                  voice: Stealth.config.twilio_voice.voice
                )
              when "delay"
                # Pause options: https://www.twilio.com/docs/voice/twiml/pause
                r.pause(length: reply["duration"])
              when "play"
                # Play options: https://www.twilio.com/docs/voice/twiml/play
                loop_val = reply["loop"] || 1
                r.play(loop: loop_val, url: reply["url"])
              when "gather"
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

                r.gather(
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
              end
            end
          end.to_s

          {
            type: :speech,
            msg: voice_reply
          }
        end
      end
    end
  end
end
