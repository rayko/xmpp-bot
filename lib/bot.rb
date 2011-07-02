require "bot-client"
require "bot-mucclient"
require "sqlite3"

class Bot
  attr_accessor :nick, :resource, :jid_data, :room_data, :bot_client, :bot_muc, :db
  def initialize
    self.jid_data = YAML::load(File.open("../data/jids.yml"))["daverak"]
    self.room_data = YAML::load(File.open("../data/muc-rooms.yml"))["dra"]

    # Just for the begining I'll hardcode this settings
    self.nick = "Daverak"
    self.resource = "BOT"

    self.setup_db
  end

  def setup_db
    if File.exist? '../db/bot.db'
      self.db = SQLite3::Database.open '../db/bot.db'
    else
      self.db = SQLite3::Database.new '../db/bot.db'
      self.db.execute "CREATE TABLE counters (name string, count integer)"
    end
  end

  def start_client
    self.bot_client = BotClient.new self.jid_data
  end

  def stop_client
    self.bot_client.client.close!
  end

  def start_mucclient
    self.bot_muc = BotMUCClient.new self.room_data, self.bot_client.client
    self.setup_callbacks
  end

  def stop_mucclient
    self.bot_muc.close_muc
  end

  def send_to_chat m
    self.bot_muc.muc.send m
  end

  def simple_send text
    self.bot_muc.muc.send  Message.new.set_body(text)
  end

  def setup_callbacks
    self.bot_muc.muc.add_private_message_callback do |message|
      puts message.inspect
      body = message.body
      body = body.split " "
      body.reverse!
      if body.pop == "$say" && ["Rayko", "Rayko (The Camper)"].include?(message.from.split('/')[1])
        self.simple_send body.reverse.join(' ')
      end
    end
  end

  def run
    self.start_client
    self.start_mucclient
  end

  def end
    self.stop_mucclient
    self.stop_client
  end

end
