class Room < ApplicationRecord

  include ActiveChapter

  belongs_to :chapter
  belongs_to :door

  has_many :edges, foreign_key: 'room_parent_id'
  has_many :available_rooms, through: :edges, source: :child_room

  validates :door_id, presence: true
  validates :chapter, presence: true
  validates :number , presence: true,
                      numericality: {
                                      greater_than_or_equal_to: 1,
                                      less_than_or_equal_to: 45
                                    }

  before_validation :assign_door
  before_validation :assign_chapter

  scope :active, -> (chapter_id) { where(chapter_id: chapter_id) }

  delegate :thumbnail, to: :door, prefix: false, allow_nil: true

  def assign_door
    door  = if final
              Door.find_by(final: true)
            else
              door_id = ( Door.all_ids - used_door_ids ).sample
              Door.find_by(id: door_id)
            end

    self.door = door
  end
  
  def used_door_ids
    chapter.rooms.pluck(:door_id)
  end

end
