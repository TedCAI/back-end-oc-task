class UserAction < ApplicationRecord

  validates :user   , presence: true
  validates :chapter, presence: false
  validates :room   , presence: true
  
  belongs_to :user
  # belongs_to :chapter
  belongs_to :room
  
  class << self
    def results(chapter_id)
      chapter = Chapter.find_by(id: chapter_id)
      user_actions_of_chapter = UserAction.where(room_id: chapter&.room_ids)
      result = []
      if chapter && user_actions_of_chapter.present?
        final_room = chapter.rooms.find_by(final: true)
        room_count = chapter.rooms.count
        start_action_ids = user_actions_of_chapter.where(chapter_id: nil).order(id: :asc).map(&:id)
        end_action_ids = user_actions_of_chapter.where(room_id: final_room).order(id: :asc).map(&:id)
        
        while(1)
          start_action_id ||= start_action_ids.pop
          end_action_id ||= end_action_ids.pop
          
          if start_action_id < end_action_id
            steps_count = end_action_id - start_action_id + 1
            result << {steps_count: steps_count, room_count: room_count, score: score(steps_count, room_count), chapter_id: chapter_id}
            end_action_id = nil
          end
          
          break if start_action_ids.size == 0 && end_action_ids.size == 0
          
          start_action_id = nil
          next
        end
      end
      result
    end
    
    def score(steps, room_count)
      steps / room_count.to_f
    end
    
    def result_details
      result_arr = []
      Chapter.all.find_each do |cp|
        result_arr += results(cp.id)
      end
      result_arr
    end
  end

end
