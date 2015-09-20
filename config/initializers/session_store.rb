# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :redis_store, key: '_ktmt_platform_session', server: 'redis://localhost:6379/0', expire_in: 15.day
