class NotesController < ApplicationController
  def create
    FactoryBot.create(:note)
  end
end
