class TransmitterCommentsJob < ApplicationJob
  queue_as :default

  def perform(event, photo, mail)
    EventMailer.comment(event, photo, mail).deliver_later
  end
end
