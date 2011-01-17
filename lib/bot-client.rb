require "rubygems"
require "xmpp4r/client"
require "xmpp4r/roster"
include Jabber

class BotClient
  attr_accessor :jid_data, :client, :jid, :jids, :presence, :bot_roster


  def initialize data
    self.jid = JID::new([data["jid"], data["nick"]].join("/"))
    self.jid_data = data
    self.client = self.create_client
    self.connect
  end

  def create_client
    self.client = Client::new self.jid
  end

  def setup_roster
    self.bot_roster.add_subscription_request_callback do |item,press|
      self.bot_roster.accept_subscription(press.from)
    end
  end

  def close
    self.client.close!
  end

  def connect
    self.client.connect
    self.client.auth self.jid_data["password"]
    self.bot_roster = Roster::Helper.new self.client
    self.setup_roster
    self.set_presence
  end

  def set_presence p=nil
    unless p.nil?
      self.presence = p
    else
      self.presence = Presence.new
    end
    self.client.send self.presence
  end

end
