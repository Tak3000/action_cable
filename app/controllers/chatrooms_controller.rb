class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy]

  # GET /chatrooms
  # GET /chatrooms.json
  def index
    @chatrooms = Chatroom.all
    
  end

  # GET /chatrooms/1
  # GET /chatrooms/1.json
  def show
    

    
  end

  # GET /chatrooms/new
  def new
    @chatroom = Chatroom.new
  end

  # GET /chatrooms/1/edit
  def edit
  end

  # POST /chatrooms
  # POST /chatrooms.json
  def create
    talking_user = User.find(params[:id])
    @current_chatroom_user = current_user.chatroom_users.build
    @talking_chatroom_user = talking_user.chatroom_users.build
    @chatroom = Chatroom.new
    
    ApplicationRecord.transaction do
      # どこか一つでも保存に失敗したら巻き戻る
      @chatroom.save!
      @current_chatroom_user.chatroom = @chatroom
      @talking_chatroom_user.chatroom = @chatroom
      @current_chatroom_user.save!
      @talking_chatroom_user.save!
    end
    
    
    # Messageを作る時の話
    @chatroom = Chatroom.find params[:chatroom_id]
    @message = Message.build user_id: params[:user_id], chatroom: @chatroom, text: params[:text]
    @message.save
    
    
    @chatroom = Chatroom.new(chatroom_params)

    respond_to do |format|
      if @chatroom.save
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully created.' }
        format.json { render :show, status: :created, location: @chatroom }
      else
        format.html { render :new }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chatrooms/1
  # PATCH/PUT /chatrooms/1.json
  def update
    respond_to do |format|
      if @chatroom.update(chatroom_params)
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully updated.' }
        format.json { render :show, status: :ok, location: @chatroom }
      else
        format.html { render :edit }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chatrooms/1
  # DELETE /chatrooms/1.json
  def destroy
    @chatroom.destroy
    respond_to do |format|
      format.html { redirect_to chatrooms_url, notice: 'Chatroom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chatroom
      @chatroom = Chatroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chatroom_params
      params.require(:chatroom).permit(:name)
    end
end
