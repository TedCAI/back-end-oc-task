class ChaptersController < ApplicationController
  before_action :set_chapter        , only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: :room
  skip_before_action :disconnect, only: :room

  def room
    room_id           = params[:room_number].to_i
    chapter_id        = params[:chapter_id]&.to_i
    
    team = Team.find_or_create_by(name: 'maze')
    if team.users.where.not(id: current_user.id).count >= 3
      flash[:notice] = 'only up to 3 players in a team'
      redirect_to root_path
    end
    @room             = chapter_id ? Chapter.find_by(id: chapter_id)&.rooms&.find_by(id: room_id) : Chapter.active&.rooms&.find_by(number: room_id)
    if @room
      current_user.update(team_id: team.id)
      _chapter_id = chapter_id #|| Chapter.active.id
      last_user_action = UserAction.last
      if (room_id == 1 && !chapter_id && team.users.where.not(id: current_user.id).map(&:id).include?(last_user_action&.user_id))
        @room = Room.find_by(id: last_user_action&.room_id)
      end
      
      unless last_user_action&.chapter_id == _chapter_id && last_user_action&.room_id == room_id
        if (!chapter_id && team.user_ids.include?(last_user_action&.user_id))
          room = Room.find_by(id: last_user_action&.room_id)
          @room = room unless room&.final
        end
        UserAction.create(user_id: current_user.id, room_id: @room.id, chapter_id: _chapter_id)
        host = Rails.env.development? ? 'http://0.0.0.0:3000' : request.host
        SendMsgJob.perform_now("#{host}/maze/room/#{@room.id}?chapter_id=#{_chapter_id}")
      end
      @available_rooms  = @room&.available_rooms.includes(:door)
      ActionCable.server.remote_connections.where(current_user: current_user).disconnect if @room.final
    else
      redirect_to chapters_url, notice: 'No active chapter'
    end
  end

  # GET /chapters
  # GET /chapters.json
  def index
    @chapters = Chapter.all
  end

  # GET /chapters/1
  # GET /chapters/1.json
  def show
  end

  # GET /chapters/new
  def new
    @active_chapter = Chapter.active
    @chapter        = Chapter.new
  end

  # GET /chapters/1/edit
  def edit
  end

  # POST /chapters
  # POST /chapters.json
  def create
    active_chapter = Chapter.active
    active_chapter.update_column :active, false if active_chapter

    @chapter = Chapter.new(chapter_params)

    respond_to do |format|
      if @chapter.save
        format.html { redirect_to @chapter, notice: 'Chapter was successfully created.' }
        format.json { render :show, status: :created, location: @chapter }
      else
        active_chapter.update_column :active, true if active_chapter
        format.html { render :new }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chapters/1
  # PATCH/PUT /chapters/1.json
  def update
    respond_to do |format|
      if @chapter.update(chapter_params)
        format.html { redirect_to @chapter, notice: 'Chapter was successfully updated.' }
        format.json { render :show, status: :ok, location: @chapter }
      else
        format.html { render :edit }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chapters/1
  # DELETE /chapters/1.json
  def destroy
    @chapter.destroy
    respond_to do |format|
      format.html { redirect_to chapters_url, notice: 'Chapter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chapter_params
      params.require(:chapter).permit(:number, :active, :rooms_count)
    end
end
