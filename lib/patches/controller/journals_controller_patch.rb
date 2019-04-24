module Pwfmt::JournalsControllerPatch
  extend ActiveSupport::Concern

  included do
    before_render :load_wiki_format, only: [:edit, :update]
    before_render :reserve_format, only: [:edit]
  end

  private

  def load_wiki_format
    @journal.load_wiki_format! if @journal.respond_to?(:load_wiki_format!)
  end

  def reserve_format
    Pwfmt::Context.reserve_format("journal_#{@journal.id}_notes", @journal.notes) if @journal.respond_to?(:notes)
  end
end

require 'journals_controller'
JournalsController.__send__(:include, Pwfmt::JournalsControllerPatch)
