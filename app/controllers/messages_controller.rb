class MessagesController < ApplicationController

	def new
		@match = Match.find(message_params[:match_id])
		@sender = User.find_by(id: session[:user_id])
		
		if session[:current_pet_id]
			if @match.pet1_id == session[:current_pet_id]
				other_pet = Pet.find_by(id: @match.pet2_id)
				@receiver = other_pet.user
			else
				other_pet = Pet.find_by(id: @match.pet1_id)
				@receiver = other_pet.user
			end
		else
			@receiver = User.find_by(id: message_params[:receiver_id])
		end
		 
	end

	def create
		@message = Message.create(message_params)
		redirect_to messages_path
	end

	def index
		@sent_messages = Message.where(sender_id: session[:user_id])  
		@received_messages = Message.where(receiver_id: session[:user_id])
		# Need create show page and then create session[:current_pet_id] if
		# it isnt set already.
	end

	def destroy
		message = Message.find_by(id: params[:id])
		message.destroy
		redirect_to messages_path
	end

	private

	def message_params
		params.require(:message).permit(:match_id, :sender_id, :receiver_id, :content)
	end
end
