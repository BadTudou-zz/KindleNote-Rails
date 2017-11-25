class ParseClippingToNoteJob < ApplicationJob
  queue_as :default
  

  def perform(*args)
    filePath = args.first
    user = args.second
    clipping = ParseClippingService.new(filePath)
        notes = clipping.parseForNote
        notes.each do |title, note|
            note_saved =  user.notes.find_by(title: note[:title].strip)
            unless note_saved
                note_saved = user.notes.create(title: note[:title].strip, author: note[:author], rating: 0)
                StoreNoteInfoFromDoubanJob.perform_later note_saved.id
            end
            fragments = note[:fragment]
            fragments.each do |fragment|
            begin
                Fragment.create(note_id: note_saved.id, 
                            user_id: user.id,
                            fragment_type: fragment[:type], 
                            content: fragment[:content],
                            datetime: fragment[:date]
                            )
            rescue Exception => e
                puts e
                next
            end
            ActionCable.server.broadcast "web_notifications_channel#{user.id}", title: '提示', message: "笔记#{note_saved.title}解析完成"
        end
    end
  end
end