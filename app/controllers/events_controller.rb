class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    @people = Person.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @people = Person.all
    @person = Person.new
  end

  # GET /events/1/edit
  def edit
    @people = Person.all
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.payer_id = params[:payer_id]

    friends_no = params[:friends].values.map{ |s| s.to_i }.inject(:+)
    attendees_no = friends_no + params[:attendees].length

    if attendees_no > 0
      @event.cost_per_person = @event.cost_total / attendees_no
    end

    for email in params[:attendees]
      @event.people << Person.find_by(email: email)
    end

    # @event.people << Person
    respond_to do |format|
      if @event.save

        # update payer's money
        payer = Person.find_by(id: @event.payer_id)
        payer.money += @event.cost_total
        payer.save
        @event.save

        # update each attendee's money
        params[:attendees].each do |email|
          person = Person.find_by(email: email)
          person.money -= @event.cost_per_person * ( 1 + params[:friends][email].to_i)
          person.save
        end

        # record the cost of each person at each event
        params[:attendees].each do |email|
          person = Person.find_by(email: email)
          cost = Cost.new
          cost.person_id = person.id
          cost.event_id = @event.id
          cost.money = @event.cost_per_person * ( 1 + params[:friends][email].to_i)
          cost.save
        end


        email_obj = {}
        email_obj["to"] = Person.all.map{|p| p.email}
        email_obj["subject"] = 'Badminton Expense Update'
        email_obj["body"] = render_to_body(:template => "events/index", :layout => false)
        # UserMailer.deliver_report(email_obj).deliver

        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:date, :place, :cost_total, :attendees, :payer_id)
    end
end
