class DatasController < ApplicationController
  before_action :authenticate_admin!, only: [:admin, :update]
  before_action :authenticate_user!, only: [:index, :create]

  COLORS = ["AliceBlue",  "AntiqueWhite","Aqua","Aquamarine","Bisque","Black", "Blue","BlueViolet","Brown", "BurlyWood", "CadetBlue", "Chartreuse","Chocolate", "Coral", "CornflowerBlue","Cornsilk","Crimson", "Cyan","DarkBlue","DarkCyan","DarkGoldenRod", "DarkGrey","DarkGreen", "DarkKhaki", "DarkMagenta", "DarkOliveGreen","DarkOrange","DarkOrchid","DarkRed", "DarkSalmon","DarkSeaGreen","DarkSlateBlue", "DarkTurquoise", "DarkViolet","DeepPink","DeepSkyBlue", "DimGray", "DodgerBlue","FireBrick", "FloralWhite", "ForestGreen", "Fuchsia", "Gainsboro", "GhostWhite","Gold","GoldenRod", "Gray","Green", "GreenYellow", "HoneyDew","HotPink", "IndianRed", "Indigo",  "Ivory", "Khaki", "Lavender","LavenderBlush", "LawnGreen", "LemonChiffon","LightBlue", "LightCoral","LightCyan", "LightGoldenRodYellow","LightGreen","LightPink", "LightSalmon", "LightSeaGreen", "LightSkyBlue","LightSlateGrey","LightSteelBlue","LightYellow", "Lime","LimeGreen", "Linen", "Magenta", "Maroon","MediumAquaMarine","MediumBlue","MediumOrchid","MediumPurple","MediumSeaGreen","MediumSlateBlue", "MediumSpringGreen", "MediumTurquoise", "MediumVioletRed", "MintCream", "MistyRose", "OldLace", "Olive", "OliveDrab", "Orange","OrangeRed", "Orchid","PaleGoldenRod", "PaleGreen", "PaleTurquoise", "PaleVioletRed", "PapayaWhip","PeachPuff", "Peru","Pink","Plum","PowderBlue","Purple","RebeccaPurple", "Red", "RosyBrown", "RoyalBlue", "SaddleBrown", "Salmon","SandyBrown","SeaGreen","SeaShell","Sienna","Silver","SkyBlue", "SlateBlue", "SlateGrey", "SpringGreen", "SteelBlue", "Tan", "Teal","Thistle", "Tomato","Turquoise", "Violet","Wheat", "WhiteSmoke","Yellow","YellowGreen"]
  COLSIZES = [[8,"h2"],[8,"h6"],[4,"h2"],[12,"h4"],[4,"h3"],[4,"h4"],[4,"h2"],[12,"h4"],[8,"h6"],[8,"h4"],[4,"h3"],[12,"h4"]]

  def index
    @colors = COLORS
    @col_sizes = COLSIZES
    @event = Event.where(created_at: Time.now.beginning_of_day.utc..Time.now.end_of_day.utc).first_or_create!
    @contacts = Event.first.contacts + @event.contacts
    @contact = Contact.new
  end

  def create
    @event = Event.where(created_at: Time.now.beginning_of_day.utc..Time.now.end_of_day.utc).first_or_create!
    @contact = Contact.new(
                            email: params[:email],
                            first_name: params[:first_name],
                            last_name: params[:last_name],
                            phone: params[:phone],
                            interested_in: params[:interested_in],
                            slides: params[:slides],
                            event_id: @event.id
                          )

    if @contact.save
      ContactMailer.contact_me_email(@contact).deliver_now
      flash[:success] = "Thank you, You'll recieve info shortly."
      redirect_to "/"
    else
      @colors = COLORS
      @col_sizes = COLSIZES
      @contacts = Event.first.contacts + @event.contacts
      @errors = @contact.errors.full_messages
      render :index
    end
  end

  def admin
    @contacts = Contact.where("id > ?", 7)
    search_term = params[:search_term]
    @contacts = @contacts.where("first_name iLIKE ? OR last_name iLIKE ? OR email iLIKE ? OR phone iLIKE ? OR interested_in iLIKE ?", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%") if search_term
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    @contact.assign_attributes(
                                email: params[:email],
                                first_name: params[:first_name],
                                last_name: params[:last_name],
                                phone: params[:phone],
                                interested_in: params[:interested_in],
                                slides: params[:slides],
                              )

    if @contact.save
      ContactMailer.contact_update_email(@contact).deliver_now
      flash[:success] = "Updated #{@contact.full_name}"
      redirect_to "/admin"
    else
      @errors = @contact.errors.full_messages
      render :edit
    end
  end
end

