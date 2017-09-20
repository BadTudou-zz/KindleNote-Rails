class ParseClippingToNoteJob < ApplicationJob
  queue_as :default

  def perform(*args)
    filePath = args.first
    clipping = ParseClippingService.new(filePath)
    notes = clipping.parseForNote
    notes.each do |title,note|
        note_saved = Note.create(title: title, author: note[:author])
        fragments = note[:fragment]
        fragments.each do |fragment|
            Fragment.create(note_id: note_saved.id, 
                            fragment_type: fragment[:type], 
                            content: fragment[:content],
                            datetime: fragment[:date]
                            )
        end
    end
 
  end
end
