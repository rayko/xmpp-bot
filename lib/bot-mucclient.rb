require "rubygems"
require "xmpp4r/client"
require "xmpp4r/muc"

class BotMUCClient
  attr_accessor :rooms, :muc, :jid

  def initialize data, client
    self.rooms = data
    self.jid = Jabber::JID.new [data["jid"], data["nick"]].join("/")
    self.create_client client
    self.join_room self.jid
  end

  def create_client client
    self.muc = Jabber::MUC::MUCClient.new client
  end

  def join_room room
    self.muc.join room
  end

  def close_muc
    self.muc.exit
  end


end
