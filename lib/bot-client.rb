require "rubygems"
require "xmpp4r/client"
include Jabber

class BotClient
  attr_accessor :jid_data, :client, :jid, :jids, :presence


  def initialize data=nil
    unless data.nil?
      self.jid_data = data
    end
    self.jids = YAML::load(File.open("../data/jids.yml"))
  end

  def setup_jid data=nil
    unless data.nil?
      self.jid = JID::new([data["jid"], data["nick"]].join("/"))
      self.jid_data = data
    end
    return nil
  end

  def create_client
    self.client = Client::new self.jid
  end

  def connect
    self.client.connect
    self.client.auth self.jid_data["password"]
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
