# frozen_string_literal: true

module ClaudeOnRails
  class Configuration
    attr_accessor :default_model, :vibe_mode, :session_directory, :log_directory

    def initialize
      @default_model = 'opus'
      @vibe_mode = true
      @session_directory = '.claude-on-rails/sessions'
      @log_directory = '.claude-on-rails/logs'
    end

    def to_h
      {
        default_model: default_model,
        vibe_mode: vibe_mode,
        session_directory: session_directory,
        log_directory: log_directory
      }
    end
  end
end
