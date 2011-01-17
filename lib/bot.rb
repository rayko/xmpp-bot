require "bot-client"
require "bot-mucclient"

class Bot
  attr_accessor :nick, :resource, :jid_data, :room_data, :bot_client, :muc
  def initialize
    self.jid_data = YAML::load(File.open("../data/jids.yml"))["daverak"]
    self.room_data = YAML::load(File.open("../data/muc-rooms.yml"))["dra"]

    # Just for the begining I'll hardcode this settings
    self.nick = "Daverak"
    self.resource = "BOT"
  end

  def start_client
    self.bot_client = BotClient.new self.jid_data
  end

  def stop_client
    self.bot_client.client.close!
  end

  def start_mucclient
    self.muc = BotMUCClient.new self.room_data, self.bot_client.client
  end

  def stop_mucclient
    self.muc.close_muc
  end
end
