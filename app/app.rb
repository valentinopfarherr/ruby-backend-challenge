require 'cuba'
require 'json'
require 'rack/contrib/json_body_parser'
require 'rack/session/cookie'
require 'securerandom'
require 'rack/deflater'

require_relative 'routes'
require_relative 'utilities'

Cuba.use Rack::Session::Cookie, secret: SecureRandom.hex(64)
Cuba.use Rack::Deflater
Cuba.use Rack::JSONBodyParser

Cuba.define do
  extend Utilities

  @users = load_users
  @products = load_products

  Routes.define(self)
end
