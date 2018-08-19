module ActiveChapter

  def assign_chapter
    self.chapter_id = Chapter.active&.id
  end

end