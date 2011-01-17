require "rubygems"
require "xmpp4r/client"
require "xmpp4r/muc"

class BotMUCClient
  attr_accessor :rooms, :muc, :jid

  def initialize
    self.rooms = YAML::load(File.open("../data/muc-rooms.yml"))
  end

  def setup_jid data=nil
    unless data.nil?
      self.jid = Jabber::JID.new [data["jid"], data["nick"]].join("/")
    end
    return nil
  end

  def create_client client
    self.muc = Jabber::MUC::MUCClient.new client
  end

  def join_room room=nil
    unless room.nil?
      self.muc.join room
    else
      self.muc.join self.jid
    end
  end

  def close_muc
    self.muc.exit
  end


end
